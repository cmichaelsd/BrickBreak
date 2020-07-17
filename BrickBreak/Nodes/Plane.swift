//
//  Plane.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class Plane: Primitive {
    
    override func buildVertices() {
        // create vertices and do not repeat vertices
        vertices = [
            Vertex(position: float3(-1, 1, 0), color: float4(1, 0, 0, 1), texture: float2(0, 1)),  // V0
            Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), texture: float2(0, 0)), // V1
            Vertex(position: float3(1, -1, 0), color: float4(0, 0, 1, 1), texture: float2(1, 0)),  // V2
            Vertex(position: float3(1, 1, 0), color: float4(1, 0, 1, 1), texture: float2(1, 1)),   // V3
        ]
        
        // create indices which reference which 4 vertices to use from the vertices array
        indices = [
            0, 1, 2,
            2, 3, 0
        ]
    }
}
