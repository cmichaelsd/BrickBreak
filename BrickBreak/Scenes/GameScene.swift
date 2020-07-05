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
    
    override init(device: MTLDevice, size: CGSize) {
        quad = Plane(device: device, imageName: "picture.png", maskImageName: "picture-frame-mask.png")
        super.init(device: device, size: size)
        add(childNode: quad)
        let pictureFrame = Plane(device: device, imageName: "picture-frame.png", maskImageName: nil)
        add(childNode: pictureFrame)
    }
}
