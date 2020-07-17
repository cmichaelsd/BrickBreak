//
//  Node.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Node {
    
    var name = "Untitled"
    var children: [Node] = []
    
    var specularIntensity: Float = 1
    var shininess: Float = 1
    
    var materialColor = float4(repeating: 1)
    
    var position = float3(repeating: 0)
    var rotation = float3(repeating: 0)
    var scale = float3(repeating: 1)
    
    var width: Float = 1
    var height: Float = 1
    
    // local model matrix specific to each instance of Node / each model
    var modelMatrix: matrix_float4x4 {
        // set position
        var matrix =  matrix_float4x4(translationX: position.x, y: position.y, z: position.z)
        
        // set rotation
        matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.z,x: 0, y: 0, z: 1)
        
        // set scale
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        
        return matrix
    }
    
    func add(childNode: Node) {
        children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        
        // multiply each parent matrix by the childs, movement of a parent object affects childrens
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        
        for child in children {
            // recurse and send the newly created model view matrix to each child Node
            child.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
        
        // command encoder pushDebugGroup and popDebugGroup methods allow inspection of each nodes render commands
        // when using the GPU debugger more easily by pushing the name of the node you're currently rendering.
        // can remove these lines on app release
        if let renderable = self as? Renderable {
            commandEncoder.pushDebugGroup(name)
            renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix)
            commandEncoder.popDebugGroup()
        }
    }
    
    func boundingBox(_ parentModelViewMatrix: matrix_float4x4) -> CGRect {
        
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        
        var lowerLeft = float4(-width / 2, -height / 2, 0, 1)
        lowerLeft = matrix_multiply(modelViewMatrix, lowerLeft)
        
        var upperRight = float4(width / 2, height / 2, 0, 1)
        upperRight = matrix_multiply(modelViewMatrix, upperRight)
        
        let boundingBox = CGRect(
            x: CGFloat(lowerLeft.x),
            y: CGFloat(lowerLeft.y),
            width: CGFloat(upperRight.x - lowerLeft.x),
            height: CGFloat(upperRight.y - lowerLeft.y)
        )
        
        return boundingBox
    }
    
}
