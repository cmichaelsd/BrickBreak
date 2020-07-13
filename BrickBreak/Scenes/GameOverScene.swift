//
//  GameOverScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/13/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class GameOverScene: Scene {
    
    var gameOverModel: Model!
    var registerTouch = false
    var time: Float = 0
    
    var win: Bool = false {
        didSet {
            if win {
                gameOverModel = Model(device: device, modelName: "youwin")
                gameOverModel.materialColor = float4(0, 1, 0, 1)
            } else {
                gameOverModel = Model(device: device, modelName: "youlose")
                gameOverModel.materialColor = float4(1, 0, 0, 1)
            }
            add(childNode: gameOverModel)
        }
    }
    
    override init(device: MTLDevice, size: CGSize) {
        super.init(device: device, size: size)
        
        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.3
        light.diffuseIntensity = 0.8
        light.direction = float3(0, -1, -1)
        
        camera.position.z = -30
    }
    
    override func update(deltaTime: Float) {
        time += deltaTime
        let amplitude: Float = 0.5
        let period: Float = 2
        let periodicAmount = sin(Float(time + 0.8) * period) * amplitude * deltaTime
        
        gameOverModel.rotation.x -= π * periodicAmount
        gameOverModel.scale += float3(repeating: periodicAmount / 4)
    }
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        registerTouch = true
    }
    
    override func touchesEnded(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) {
        if registerTouch {
            let scene = GameScene(device: device, size: size)
            sceneDelegate?.transition(to: scene)
        }
    }
}
