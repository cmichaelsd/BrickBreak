//
//  SampleRoom.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/19/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class SpaceScene: Scene {
    
    enum Constants {
        static let height: Float = 48
        static let width: Float = 27
    }
    
    let sun: Planet
//    let mercury: Model
//    let venus: Model
    let earth: Planet
    let moon: Planet
    
    var previousTouchLocation: CGPoint = .zero
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Planet(
            device: device,
            imageName: "sun.jpg",
            scale: float3(repeating: 10.0),
            x: Constants.width / 2,
            y: Constants.height / 2,
            z: 0.0
        )
//        mercury = Model(device: device, modelName: "sun")
//        venus = Model(device: device, modelName: "sun")
        earth = Planet(
            device: device,
            imageName: "earth.jpg",
            scale: float3(repeating: 5.0),
            x: sun.model.position.x + 35,
            y: Constants.height / 2,
            z: 0.0
        )
        moon = Planet(
            device: device,
            imageName: "moon.jpg",
            scale: float3(repeating: 0.3),
            x: 2.0,
            y: 1.0,
            z: 0.0
        )
        super.init(device: device, size: size)
        
        camera.farZ = 300
        camera.position.z = -100
        camera.position.x = -Constants.width / 2
        camera.position.y = -Constants.height / 2
        
//        light.color = float3(arrayLiteral: 1, 1, 1)
//        light.ambientIntensity = 0.3
//        light.diffuseIntensity = 0.8
//        light.direction = float3(arrayLiteral: Constants.width / 2, Constants.height / 2, 0)
        setupScene()
    }
    
    override func update(deltaTime: Float) {
        earth.update(
            deltaTime: deltaTime,
            distanceFromOrigin: 35,
            originX: sun.model.position.x,
            originZ: 0,
            increment: 0.01,
            rotates: true
        )
        moon.update(
            deltaTime: deltaTime,
            distanceFromOrigin: 2,
            originX: 0,
            originZ: 0,
            increment: 0.05,
            rotates: false
        )
//        moon.update(originX: 0, originY: 0, increment: 0.05)
    }
    
    func setupScene() {
        add(childNode: sun.model)
        
//        mercury.position.x = 2
//        mercury.scale = float3(repeating: 0.1)
//        mercury.materialColor = float4(arrayLiteral: 1, 0, 0, 1)
//        sun.add(childNode: mercury)
//
//        venus.position.x = 2
//        venus.scale = float3(repeating: 0.1)
//        venus.materialColor = float4(arrayLiteral: 1, 0, 0, 1)
//        sun.add(childNode: venus)
        
        add(childNode: earth.model)
        earth.model.add(childNode: moon.model)
    }
    
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
