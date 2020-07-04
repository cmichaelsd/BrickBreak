//
//  Texturable.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/4/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        
        // declare texture
        var texture: MTLTexture? = nil
        
        // establish texture loading options
        let textureLoaderOptions: [MTKTextureLoader.Option: Any]
        // different versions of swift load from different points, ensure loading if from bottom left
        let origin = MTKTextureLoader.Origin.bottomLeft
        // set bottom left origin as an option for texture loading
        textureLoaderOptions = [MTKTextureLoader.Option.origin: origin]
        
        // create a texture url from the image name
        // note folder structure has to be a specific way
        // 'Images' must be a group with imageName file in the group
        // else this followering line will always be nil
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                // set texture
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
                return texture
            } catch {
                print("texture not created")
            }
        }
        
        return nil
    }
}
