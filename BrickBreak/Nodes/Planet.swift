//
//  Planet.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/21/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Planet: Node {
    var angle: Float = Float.random(in: 0...π * 2)
    var distanceFromOrigin: Float
    let model: Model
    init(
        device: MTLDevice,
        modelName: String,
        imageName: String,
        distanceFromOrigin: Float,
        scale: float3,
        x: Float,
        y: Float,
        z: Float
    ) {
        self.distanceFromOrigin = distanceFromOrigin
        model = Model(device: device, modelName: modelName, imageName: imageName)
        model.scale = scale
        model.position.x = x + distanceFromOrigin
        model.position.y = y
        model.position.z = z
    }
    
    func revolution(originX: Float, originZ: Float, speed: Float) {
        let newX = originX + cos(angle) * distanceFromOrigin
        let newZ = originZ + sin(angle) * distanceFromOrigin

        // planets in this solar system revolve counterclockwise
        if angle <= -TWO_PI {
            angle = 0.0
        } else {
            angle -= divisionOfPi() * speed
        }

        model.position.x = newX
        model.position.z = newZ
    }
    
    func rotation(counterClockwise: Bool, speed: Float) {
        // divide pi into how many standard increments you are using
        // 365 days
        if counterClockwise {
            model.rotation.y -= divisionOfPi() * speed
        } else {
            model.rotation.y += divisionOfPi() * speed
        }
    }
    
    private func divisionOfPi() -> Float {
        return π / 365
    }
}
