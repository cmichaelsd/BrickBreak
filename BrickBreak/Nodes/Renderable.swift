//
//  Renderable.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    var vertexFunctionName: String { get }
    var fragmentFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
    var modelConstants: ModelConstants { get set }
    
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
}

extension Renderable {
    // create a library to interact and define metal Shader functions
    // init a pipelineDescriptor
    // describe which function on the pipelineDescriptor uses which shader function
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState? {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexFunctionName)
        let fragmentFunction = library?.makeFunction(name: fragmentFunctionName)

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // assign vertex descriptor to pipline vertex descriptor
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        let pipelineState: MTLRenderPipelineState

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            return pipelineState
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
}
