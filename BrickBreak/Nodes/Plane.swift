//
//  Plane.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Plane: Node {
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // describing the position attribute on the vertex structure
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        // describing the color attribute on the vertex structure
        // offset by stride of first entry
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        // describing the texture on the vertex structure
        // offset by stride of first and second entry
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        
        // define the size of the vertex
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }
    
    // Texturable
    var texture: MTLTexture?
    
    // mask texture
    var maskTexture: MTLTexture?
    
    // create vertices and do not repeat vertices
    var vertices: [Vertex] = [
        Vertex(position: SIMD3<Float>(-1, 1, 0), color: SIMD4<Float>(1, 0, 0, 1), texture: SIMD2<Float>(0, 1)),  // V0
        Vertex(position: SIMD3<Float>(-1, -1, 0), color: SIMD4<Float>(0, 1, 0, 1), texture: SIMD2<Float>(0, 0)), // V1
        Vertex(position: SIMD3<Float>(1, -1, 0), color: SIMD4<Float>(0, 0, 1, 1), texture: SIMD2<Float>(1, 0)),  // V2
        Vertex(position: SIMD3<Float>(1, 1, 0), color: SIMD4<Float>(1, 0, 1, 1), texture: SIMD2<Float>(1, 1)),   // V3
    ]
    
    // create indices which reference which 4 vertices to use from the vertices array
    var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    struct Constants {
        var animateBy: Float = 0.0
    }
    
    var constants = Constants()
    
    var time: Float = 0
    
    init(device: MTLDevice, imageName: String, maskImageName: String?) {
        super.init()
        buildBuffers(device: device)
        
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        if (maskImageName != nil) {
            if let maskTexture = setTexture(device: device, imageName: maskImageName!) {
                self.maskTexture = maskTexture
                fragmentFunctionName = "textured_mask_fragment"
            }
        }
        
        
        pipelineState = buildPipelineState(device: device)
    }
    
    // vertices are stored in a Metal buffer
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime)
        
        guard let indexBuffer = indexBuffer else { return }
        
        time += deltaTime
        
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animateBy = animateBy
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        
        // send the Metal buffer to the GPU, these vertices will be referenced by the indexed draw below
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // set texture of fragment to texture at fragment index 0
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        if (maskTexture != nil) {
            // set mask textures fragment at the next available index
            commandEncoder.setFragmentTexture(maskTexture, index: 1)
        }
        
        // use indices instead of vertex for drawing, saves memory
        // commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: indices.count,
            indexType: .uint16,
            indexBuffer: indexBuffer,
            indexBufferOffset: 0
        )
    }
}

extension Plane: Renderable {}

extension Plane: Texturable {}
