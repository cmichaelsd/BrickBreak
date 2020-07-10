//
//  LandscapeScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/9/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class LandscapeScene: Scene {
    
    let sun: Model
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Model(device: device, modelName: "sun")
        super.init(device: device, size: size)
        sun.materialColor = SIMD4<Float>(arrayLiteral: 1, 1, 0, 1)
        add(childNode: sun)
    }
    
    override func update(deltaTime: Float) {
        
    }
}
