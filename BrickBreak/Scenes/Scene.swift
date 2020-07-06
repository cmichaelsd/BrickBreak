//
//  Scene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        // create a matrix as a camera removed -4 on teh z
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4)
        
        for child in children {
            // recurse and send the newly created view matrix to each child Node
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }
    
    func update(deltaTime: Float) {}
}
