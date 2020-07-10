//
//  Model.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/9/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Model: Node {
    var meshes: ([MDLMesh], [MTKMesh])?
    
    // Textureable
    var texture: MTLTexture?
    
    // Renderable
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = "fragment_shader"
    var vertexFunctionName: String = "vertex_shader"
    var modelConstants = ModelConstants()
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // describing the position attribute on the vertex structure
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        // describing the color attribute on the vertex structure
        // offset by stride of first entry
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        // describing the texture on the vertex structure
        // offset by stride of first and second entry
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        // describe normals
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0

        
        // define the size of the vertex
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12
        return vertexDescriptor
    }
    
    init(device: MTLDevice, modelName: String) {
        super.init()
        name = modelName
        loadModel(device: device, modelName: modelName)
        
        let imageName = modelName + ".png"
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        
        pipelineState = buildPipelineState(device: device)
    }
    
    func loadModel(device: MTLDevice, modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) does not exist")
        }
        
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attributePosition
        
        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
        attributeColor.name = MDLVertexAttributeColor
        descriptor.attributes[1] = attributeColor
        
        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
        attributeTexture.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = attributeTexture
        
        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = attributeNormal
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: descriptor, bufferAllocator: bufferAllocator)
        
        do {
            meshes = try MTKMesh.newMeshes(asset: asset, device: device)
        } catch {
            print("mesh error")
        }
    }
    
}

extension Model: Renderable {
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        modelConstants.modelViewMatrix = modelViewMatrix
        
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, index: 1)
        
        if texture != nil {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        
        commandEncoder.setRenderPipelineState(pipelineState)
        
        guard let meshes = meshes?.1,
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
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
    }
}

extension Model: Texturable {}
