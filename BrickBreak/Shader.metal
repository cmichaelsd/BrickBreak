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

// define the vertex structure used in Types
struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinates;
};

// vertex is the type of function
// return type is float4
// function name is vertex_shader

// parameters
// vertices - a pointer to a vertices array created in the function initalization
// &constant - constant space as opposed to device space, Constant is the time property, &constants variable name; constant struct byte are allocated to buffer 1
// vertexId - the id of the current vertex being processed by the GPU

// return
// float4 returns current vertex from vertices array the GPU is processing

// the output of this function is the input in the next stage of the pipeline
// the GUP assembles the vertices into triangle primitives
// the rasterizer takes over and splits the triangle into fragments
// the fragment function function returns the color of each fragment

// processes the real position of each vertex
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]) {
    
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    
    return vertexOut;
}

// fragment is the type
// return type is half4
// function name is fragment_shader

// return
// half4 (a smaller float4) R:1, G:0, B:0, A:1 - Red

// returns the color
fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}

//new second parameter is sample type, linear instead of nearest
// new third parameter is texture in fragment buffer 0
fragment half4 textured_fragment(
    VertexOut vertexIn [[ stage_in ]],
    sampler sampler2d [[ sampler(0) ]],
    texture2d<float> texture [[ texture(0) ]]
) {
    
    //extract color from current textures fragment coordinates
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    if (color.a == 0.0)
        discard_fragment();
    
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 textured_mask_fragment(
    VertexOut vertexIn [[ stage_in ]],
    texture2d<float> texture [[ texture(0) ]],
    texture2d<float> maskTexture [[ texture(1) ]],
    sampler sampler2d [[ sampler(0) ]]
) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    float4 maskColor = maskTexture.sample(sampler2d, vertexIn.textureCoordinates);
    
    float maskOpacity = maskColor.a;
    if (maskOpacity < 0.5)
        discard_fragment();
    
    return half4(color.r, color.g, color.b, 1);
}
