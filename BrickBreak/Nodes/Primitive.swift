//
//  Primitive.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/8/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Primitive: Node {
    
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
    var vertices: [Vertex] = []
    
    // create indices which reference which 4 vertices to use from the vertices array
    var indices: [UInt16] = []
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var modelConstants = ModelConstants()
    
    var time: Float = 0
    
    init(device: MTLDevice, imageName: String, maskImageName: String) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        if let maskTexture = setTexture(device: device, imageName: maskImageName) {
            self.maskTexture = maskTexture
            fragmentFunctionName = "textured_mask_fragment"
        }
        
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    func buildVertices() {}
    
    // vertices are stored in a Metal buffer
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
}

extension Primitive: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let indexBuffer = indexBuffer else { return }
        
        // multiply projection matrix by model view matrix to get the new model view matrix with depth
        modelConstants.modelViewMatrix = modelViewMatrix
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        
        // send the Metal buffer to the GPU, these vertices will be referenced by the indexed draw below
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // set texture of fragment to texture at fragment index 0
        commandEncoder.setFragmentTexture(texture, index: 0)
        
        // set mask textures fragment at the next available index
        commandEncoder.setFragmentTexture(maskTexture, index: 1)
        
        // set winding order so back face culling happens instead of front face culling
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        
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

extension Primitive: Texturable {}
