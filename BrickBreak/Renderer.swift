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
    
    var scene: Scene?
    
    var sampleState: MTLSamplerState?
    // define depth to the application
    var depthStencilState: MTLDepthStencilState?
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        super.init()
        buildSampleState()
        buildDepthStencilState()
    }
    
    private func buildSampleState() {
        // create sample state descriptor
        let descriptor = MTLSamplerDescriptor()
        // sample filter to linear instead of nearest
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        sampleState = device.makeSamplerState(descriptor: descriptor)
    }
    
    private func buildDepthStencilState() {
        // create a description of applications depth
        let depthStencilStateDescriptor = MTLDepthStencilDescriptor()
        // use less to check if any fragment is closer
        depthStencilStateDescriptor.depthCompareFunction = .less
        // record depth value
        depthStencilStateDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilStateDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        
        commandEncoder?.setFragmentSamplerState(sampleState, index: 0)
        commandEncoder?.setDepthStencilState(depthStencilState)
        
        scene?.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}
