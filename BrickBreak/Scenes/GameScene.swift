//
//  GameScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    // debug
    var previousTouchLocation: CGPoint = .zero
    
    enum Constants {
        static let gameHeight: Float = 48
        static let gameWidth: Float = 27
        static let bricksPerRow = 8
        static let bricksPerColumn = 8
    }
    
    let ball: Model
    let paddle: Model
    
    let bricks: Instance
    
    override init(device: MTLDevice, size: CGSize) {
        ball = Model(device: device, modelName: "ball")
        paddle = Model(device: device, modelName: "paddle")
        bricks = Instance(device: device, modelName: "brick", instances: Constants.bricksPerRow * Constants.bricksPerColumn)
        super.init(device: device, size: size)
        
        camera.position.z = -sceneOffset(height: Constants.gameHeight + 10, fov: camera.fovRadians)
        camera.position.x = -Constants.gameWidth / 2
        camera.position.y = -Constants.gameHeight / 2
        camera.rotation.x = radians(fromDegrees: 20)
        camera.position.y = -Constants.gameHeight / 2 + 5
        
        light.color = float3(arrayLiteral: 1, 1, 1)
        light.ambientIntensity = 0.3
        light.diffuseIntensity = 0.8
        light.direction = float3(arrayLiteral: 0, -1, -1)
        setupScene()
    }
    
    func setupScene() {
        // ball
        ball.position.x = Constants.gameWidth / 2
        ball.position.y = Constants.gameHeight * 0.1
        ball.materialColor = float4(arrayLiteral: 0.5, 0.9, 0, 1)
        add(childNode: ball)
        
        // paddle
        paddle.position.x = Constants.gameWidth / 2
        paddle.position.y = Constants.gameHeight * 0.05
        paddle.materialColor = float4(arrayLiteral: 1, 0, 0, 1)
        add(childNode: paddle)
        
        // border
        let border = Model(device: device, modelName: "border")
        border.position.x = Constants.gameWidth / 2
        border.position.y = Constants.gameHeight / 2
        border.materialColor = float4(arrayLiteral: 0.51, 0.24, 0, 1)
        add(childNode: border)
        
        // bricks
        let colors = generateColors(number: Constants.bricksPerRow)
        let margin = Constants.gameWidth * 0.11
        let startY = Constants.gameHeight * 0.5
        
        for row in 0..<Constants.bricksPerRow {
            for column in 0..<Constants.bricksPerColumn {
                var position = float3(repeating: 0)
                position.x = margin + (margin * Float(row))
                position.y = startY + (margin * Float(column))
                let index = row *  Constants.bricksPerColumn + column
                bricks.nodes[index].position = position
                bricks.nodes[index].materialColor = colors[row]
            }
        }
        
        add(childNode: bricks)
        
    }
    
    override func update(deltaTime: Float) {
        for brick in bricks.nodes {
            brick.rotation.y += π / 4 * deltaTime
            brick.rotation.z += π / 4 * deltaTime
        }
    }
    
    func sceneOffset(height: Float, fov: Float) -> Float {
        return (height / 2) / tan(fov / 2)
    }
    
    
    
    // debug
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
        camera.rotation.x += Float(delta.y) * sensitivity
        camera.rotation.y += Float(delta.x) * sensitivity
        
        previousTouchLocation = touchLocation
    }
}
