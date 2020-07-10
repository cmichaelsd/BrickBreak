//
//  Instance.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/9/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Instance: Node {
    var model: Model
    
    var nodes = [Node]()
    var instanceConstants = [ModelConstants]()
    
    var modelConstants = ModelConstants()
    
    var instanceBuffer: MTLBuffer?
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var vertexFunctionName: String = "vertex_instance_shader"
    var fragmentFunctionName: String
    var vertexDescriptor: MTLVertexDescriptor
    
    init(device: MTLDevice, modelName: String, instances: Int) {
        model = Model(device: device, modelName: modelName)
        fragmentFunctionName = model.fragmentFunctionName
        vertexDescriptor = model.vertexDescriptor
        super.init()
        name = modelName
        create(instances: instances)
        makeBuffer(device: device)
        
        pipelineState = buildPipelineState(device: device)
    }
    
    func create(instances: Int) {
        for i in 0..<instances {
            let node = Node()
            node.name = "Instance \(i)"
            nodes.append(node)
            instanceConstants.append(ModelConstants())
        }
    }
    
    func makeBuffer(device: MTLDevice) {
        instanceBuffer = device.makeBuffer(
            length: instanceConstants.count * MemoryLayout<ModelConstants>.stride,
            options: []
        )
        instanceBuffer?.label = "Instance Buffer"
    }
}

extension Instance: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let instanceBuffer = instanceBuffer,
            nodes.count > 0 else {
                return
        }
        // set up pointer of type ModelConstants
        var pointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: nodes.count)
        
        // for each node
        for node in nodes {
            // get model constant property
            pointer.pointee.modelViewMatrix = matrix_multiply(modelViewMatrix, node.modelMatrix)
            // set current model constant material color from node
            pointer.pointee.materialColor = node.materialColor
            // advance pointer by 1
            pointer = pointer.advanced(by: 1)
        }
        
        commandEncoder.setFragmentTexture(model.texture, index: 0)
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(instanceBuffer, offset: 0, index: 1)
        
        guard let meshes = model.meshes?.1,
            meshes.count > 0 else {
                return
        }
        
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
            
            for submesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(
                    type: submesh.primitiveType,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset,
                    instanceCount: nodes.count
                )
            }
        }
    }
}
