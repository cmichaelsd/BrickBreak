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
    
    init(device: MTLDevice) {
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        super.init()
    }
    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
    
}
