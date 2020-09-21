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
    let mercury: Planet
    let venus: Planet
    let earth: Planet
    let moon: Planet
    let mars: Planet
    let jupiter: Planet
    let saturn: Planet
    let saturnsRings: Planet
    
    var previousTouchLocation: CGPoint = .zero
    
    override init(device: MTLDevice, size: CGSize) {
        sun = Planet(
            device: device,
            modelName: "sun",
            imageName: "sun.jpg",
            distanceFromOrigin: 0,
            scale: float3(repeating: 10.0),
            x: Constants.width / 2,
            y: Constants.height / 2,
            z: 0
        )
        mercury = Planet(
            device: device,
            modelName: "sun",
            imageName: "mercury.jpg",
            distanceFromOrigin: 15,
            scale: float3(repeating: 1.6),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        venus = Planet(
            device: device,
            modelName: "sun",
            imageName: "venus.jpg",
            distanceFromOrigin: 28,
            scale: float3(repeating: 4.8),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        earth = Planet(
            device: device,
            modelName: "sun",
            imageName: "earth.jpg",
            distanceFromOrigin: 48,
            scale: float3(repeating: 5.0),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        moon = Planet(
            device: device,
            modelName: "sun",
            imageName: "moon.jpg",
            distanceFromOrigin: 12,
            scale: float3(repeating: 2.3),
            x: earth.model.position.x,
            y: earth.model.position.y,
            z: earth.model.position.z
        )
        mars = Planet(
            device: device,
            modelName: "sun",
            imageName: "mars.jpg",
            distanceFromOrigin: 65,
            scale: float3(repeating: 2.5),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        jupiter = Planet(
            device: device,
            modelName: "sun",
            imageName: "jupiter.jpg",
            distanceFromOrigin: 85,
            scale: float3(repeating: 9.0),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        saturn = Planet(
            device: device,
            modelName: "sun",
            imageName: "saturn.jpg",
            distanceFromOrigin: 115,
            scale: float3(repeating: 8.0),
            x: sun.model.position.x,
            y: Constants.height / 2,
            z: 0
        )
        saturnsRings = Planet(
            device: device,
            modelName: "saturns_ring",
            imageName: "saturn_ring.png",
            distanceFromOrigin: 0,
            scale: float3(7.0, 2.0, 7.0),
            x: saturn.model.position.x,
            y: saturn.model.position.y,
            z: saturn.model.position.z
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
        sun.rotation(counterClockwise: true, speed: 0.037)
        
        mercury.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.011)
        mercury.rotation(counterClockwise: true, speed: 0.017)

        venus.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.004)
        venus.rotation(counterClockwise: false, speed: 0.004)
        
        earth.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.002)
        earth.rotation(counterClockwise: true, speed: 1.0)
        
        moon.revolution(originX: earth.model.position.x, originZ: earth.model.position.z, speed: 0.037)
        // darkside of moon will always face away if revolution and rotation speed are equal
        moon.rotation(counterClockwise: true, speed: 0.037)
        
        mars.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.002)
        mars.rotation(counterClockwise: true, speed: 1.03)
        
        // 11.86 years / 4328.9 days
        // 1 / 4328.9 = 0.00023101
        jupiter.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.00023101)
        jupiter.rotation(counterClockwise: true, speed: 2.439)
        
        // 26 years / 9490 days
        // 1 / 9490 = 0.00010537
        saturn.revolution(originX: sun.model.position.x, originZ: 0, speed: 0.00010537)
        saturn.rotation(counterClockwise: true, speed: 2.222)
        
        saturnsRings.revolution(originX: saturn.model.position.x, originZ: saturn.model.position.z, speed: 0.00010537)
    }
    
    func setupScene() {
        add(childNode: sun.model)
        add(childNode: mercury.model)
        add(childNode: venus.model)
        add(childNode: earth.model)
        add(childNode: moon.model)
        add(childNode: mars.model)
        add(childNode: jupiter.model)
        add(childNode: saturn.model)
        add(childNode: saturnsRings.model)
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
