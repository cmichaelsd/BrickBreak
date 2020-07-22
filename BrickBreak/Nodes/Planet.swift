//
//  Planet.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/21/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Planet: Node {
    var angle: Float = 0.0
    let model: Model
    init(device: MTLDevice, imageName: String, scale: float3, x: Float, y: Float, z: Float) {
        model = Model(device: device, modelName: "sun", imageName: imageName)
        model.scale = scale
        model.position.x = x
        model.position.y = y
        model.position.z = z
    }
    
    func update(
        deltaTime: Float,
        distanceFromOrigin: Float,
        originX: Float,
        originZ: Float,
        increment: Float,
        rotates: Bool
    ) {
        orbit(distanceFromOrigin: distanceFromOrigin, originX: originX, originZ: originZ, increment: increment)
        
        if rotates {
            rotate(deltaTime: deltaTime)
        }
    }
    
    func orbit(distanceFromOrigin: Float, originX: Float, originZ: Float, increment: Float) {
        let TWO_PI = π * 2

        let newX = originX + cos(angle) * distanceFromOrigin
        let newZ = originZ + sin(angle) * distanceFromOrigin

        // planets in this solar system orbit counterclockwise
        if angle <= -TWO_PI {
            angle = 0.0
        } else {
            angle -= increment
        }

        model.position.x = newX
        model.position.z = newZ
    }
    
    func rotate(deltaTime: Float) {
        model.rotation.y -= π / 4 * deltaTime
    }
}
