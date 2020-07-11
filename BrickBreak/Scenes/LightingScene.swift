//
//  LightingScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/10/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class LightingScene: Scene {
    let mushroom: Model
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
        
        mushroom.position.y = -1
        add(childNode: mushroom)
        
        light.color = SIMD3<Float>(arrayLiteral: 0, 0, 0.1)
        light.ambientIntensity = 1.5
    }
    override func update(deltaTime: Float) {
        
    }
}
