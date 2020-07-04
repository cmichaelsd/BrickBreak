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
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        super.init()
        buildSampleState()
    }
    
    private func buildSampleState() {
        // create sample state descriptor
        let descriptor = MTLSamplerDescriptor()
        // sample filter to linear instead of nearest
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        sampleState = device.makeSamplerState(descriptor: descriptor)
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
        
        scene?.render(commandEncoder: commandEncoder!, deltaTime: deltaTime)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}
