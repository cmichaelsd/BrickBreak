//
//  GameScene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class GameScene: Scene {
    var quad: Plane
    var cube: Cube
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png")
        cube = Cube(device: device)
        super.init(device: device, size: size)
        add(childNode: cube)
        add(childNode: quad)
        
        quad.position.z = -3
        quad.scale = SIMD3<Float>(repeating: 3)
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.y += deltaTime
    }
}
