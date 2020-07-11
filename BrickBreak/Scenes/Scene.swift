//
//  Scene.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Scene: Node {
    var camera = Camera()
    var sceneConstants = SceneConstants()
    var light = Light()
    var device: MTLDevice
    var size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        
        camera.position.z = -6
        add(childNode: camera)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        
        sceneConstants.projectionMatrix = camera.projectionMatrix
        
        commandEncoder.setFragmentBytes(&light, length: MemoryLayout<Light>.stride, index: 3)
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, index: 2)
        
        
        for child in children {
            // recurse and send the newly created view matrix to each child Node
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
        }
    }
    
    func update(deltaTime: Float) {}
    
    func sceneSizeWillChange(to size: CGSize) {
        camera.aspect = Float(size.width / size.height)
    }
}
