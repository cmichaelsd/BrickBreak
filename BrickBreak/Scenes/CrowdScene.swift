//
//  CrowdScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/9/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class CrowdScene: Scene {
    var humans = [Model]()
    
    override init(device: MTLDevice, size: CGSize) {
        super.init(device: device, size: size)
        for _ in 0..<40 {
            let human = Model(device: device, modelName: "humanFigure")
            humans.append(human)
            add(childNode: human)
            human.scale = float3(repeating: Float(arc4random_uniform(5)) / 10)
            human.position.x = Float(arc4random_uniform(5)) - 2
            human.position.y = Float(arc4random_uniform(5)) - 3
            human.materialColor = float4(arrayLiteral: Float(drand48()), Float(drand48()),Float(drand48()), 1)
        }
        
    }
    
    override func update(deltaTime: Float) {}
}
