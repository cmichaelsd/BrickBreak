//
//  GameScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    
    enum Constants {
        static let gameHeight: Float = 48
        static let gameWidth: Float = 27
    }
    
    override init(device: MTLDevice, size: CGSize) {
        super.init(device: device, size: size)
        
        camera.position.z = -sceneOffset(height: Constants.gameHeight, fov: camera.fovRadians)
        camera.position.x = -Constants.gameWidth / 2
        camera.position.y = -Constants.gameHeight / 2
        
        let mushroom = Model(device: device, modelName: "mushroom")
        add(childNode: mushroom)
        
        light.color = SIMD3<Float>(arrayLiteral: 1, 1, 1)
        light.ambientIntensity = 0.3
        light.diffuseIntensity = 0.8
        light.direction = SIMD3<Float>(arrayLiteral: 0, -1, -1)
        
    }
    
    override func update(deltaTime: Float) {
    }
    
    func sceneOffset(height: Float, fov: Float) -> Float {
        return (height / 2) / tan(fov / 2)
    }
}
