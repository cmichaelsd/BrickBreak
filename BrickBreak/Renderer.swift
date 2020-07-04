//
//  Renderer.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Renderer: NSObject {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue!
    
    // create vertices and do not repeat vertices
    var vertices: [Float] = [
       -1,  1, 0, // V0
       -1, -1, 0, // V1
        1, -1, 0, // V2
        1,  1, 0, // V3
    ]
    
    // create indices which reference which 4 vertices to use from the vertices array
    var indices: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    struct Constants {
        var animateBy: Float = 0.0
    }
    
    var constants = Constants()
    
    var time: Float = 0
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        super.init()
        buildModel()
        buildPipelineState()
    }
    
    // vertices are stored in a Metal buffer
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    // create a library to interact and define metal Shader functions
    // init a pipelineDescriptor
    // describe which function on the pipelineDescriptor uses which shader function
    private func buildPipelineState() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let pipelineState = pipelineState,
            let indexBuffer = indexBuffer,
            let descriptor = view.currentRenderPassDescriptor else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        time += 1 / Float(view.preferredFramesPerSecond)
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        let animateBy = abs(sin(time) / 2 + 0.5)
        constants.animateBy = animateBy
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        
        commandEncoder?.setVertexBytes(&constants, length: MemoryLayout<Constants>.stride, index: 1)
        
        // send the Metal buffer to the GPU, these vertices will be referenced by the indexed draw below
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // use indices instead of vertex for drawing, saves memory
        // commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}
