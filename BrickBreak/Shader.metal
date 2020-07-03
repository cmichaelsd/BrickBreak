//
//  Shader.metal
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// define the constant structure used in Render.swift so the shader function can recognize it
struct Constants {
    float animateBy;
};

// vertex is the type of function
// return type is float4
// function name is vertex_shader

// parameters
// vertices - a pointer to a vertices array created in the function initalization
// &constant - constant space as opposed to device space, Constant time property, &constants variable name; constant struct byte are allocated to buffer 1
// vertexId - the id of the current vertex being processed by the GPU

// return
// float4 returns current vertex from vertices array the GPU is processing

// the output of this function is the input in the next stage of the pipeline
// the GUP assembles teh vertices into triangle primitives
// the rasterizer takes over and splits the triangle into fragments
// the fragment function function returns the color of each fragment

// processes the real position of each vertex
vertex float4 vertex_shader(
    const device packed_float3 *vertices [[ buffer(0) ]],
    constant Constants &constants [[ buffer(1) ]],
    uint vertexId [[ vertex_id ]]
) {
    // get current vertex position
    float4 position = float4(vertices[vertexId], 1);
    // add animated motion to vertex
    position.x += constants.animateBy;
    
    return position;
}

// fragment is the type
// return type is half4
// function name is fragment_shader

// return
// half4 (a smaller float4) R:1, G:0, B:0, A:1 - Red

// returns the red color
fragment half4 fragment_shader() {
//    return half4(1, 0, 0, 1);
    return half4(1, 1, 0, 1);
}
