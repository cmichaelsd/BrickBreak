//
//  Types.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
    var texture: SIMD2<Float>
}

// each model will get a ModelConstant which will define a models relation to world space
// before sending model to the GPU multiply model matrix by view matrix to get model view matrix
// this result is the models position in 'camera space'
// multiply any matrix by and identity matrix and you get the same matrix back
struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
    var materialColor = SIMD4<Float>(repeating: 1)
    var normalMatrix = matrix_identity_float3x3
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}

struct Light {
    var color = SIMD3<Float>(repeating: 1)
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var direction = SIMD3<Float>(repeating: 0)
}
