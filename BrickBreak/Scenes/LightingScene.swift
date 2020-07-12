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
    var previousTouchLocation: CGPoint = .zero
    
    override init(device: MTLDevice, size: CGSize) {
        mushroom = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
        
        mushroom.position.y = -1
        add(childNode: mushroom)
        
        light.color = SIMD3<Float>(arrayLiteral: 1, 1, 1)
        light.ambientIntensity = 0.2
        light.diffuseIntensity = 0.8
        // set lighting direction to point toward back of screen x, y, z - z negative goes inward
        light.direction = SIMD3<Float>(arrayLiteral: 0, 0, -1)
    }
    override func update(deltaTime: Float) {}
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        previousTouchLocation = touch.location(in: view)
    }
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: view)
        let delta = CGPoint(
            x: previousTouchLocation.x - touchLocation.x,
            y: previousTouchLocation.y - touchLocation.y
        )
        
        let sensitivity: Float = 0.01
        mushroom.rotation.x += Float(delta.y) * sensitivity
        mushroom.rotation.y += Float(delta.x) * sensitivity
        
        previousTouchLocation = touchLocation
    }
}
