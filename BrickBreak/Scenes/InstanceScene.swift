//
//  InstanceScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/9/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class InstanceScene: Scene {
    var humans: Instance
    
    override init(device: MTLDevice, size: CGSize) {
        humans = Instance(device: device, modelName: "humanFigure", instances: 40)
        super.init(device: device, size: size)
        add(childNode: humans)
        for _ in 0..<40 {
            for human in humans.nodes {
                human.scale = SIMD3<Float>(repeating: Float(arc4random_uniform(5)) / 10)
                human.position.x = Float(arc4random_uniform(5)) - 2
                human.position.y = Float(arc4random_uniform(5)) - 3
                human.materialColor = SIMD4<Float>(arrayLiteral: Float(drand48()), Float(drand48()),Float(drand48()), 1)
            }
        }
        
    }
    
    override func update(deltaTime: Float) {}
}
