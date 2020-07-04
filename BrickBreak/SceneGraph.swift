//
//  SceneGraph.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/3/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

class SceneGraph: NSObject {
    
    var vertices: [Float]?
    var indices: [UInt16]?
    var children: SceneGraph?
    
    override init() {
        super.init()
    }
}
