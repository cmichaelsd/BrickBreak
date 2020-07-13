//
//  Utilities.swift
//  BrickBreak
//
//  Created by Cole Michaels on 7/12/20.
//  Copyright © 2020 cmichaelsd. All rights reserved.
//

import simd

// http://stackoverflow.com/questions/470690/how-to-automatically-generate-n-distinct-colors
func color(number: Float) -> float4 {
    var x = number
    var r: Float = 0.0
    var g: Float = 0.0
    var b: Float = 1.0
  
    if x >= 0.0 && x < 0.2 {
        x = x / 0.2
        r = 0.0
        g = x
        b = 1.0
    } else if x >= 0.2 && x < 0.4 {
        x = (x - 0.2) / 0.2
        r = 0.0
        g = 1.0
        b = 1.0 - x
    } else if x >= 0.4 && x < 0.6 {
        x = (x - 0.4) / 0.2
        r = x
        g = 1.0
        b = 0.0
    } else if x >= 0.6 && x < 0.8 {
        x = (x - 0.6) / 0.2
        r = 1.0
        g = 1.0 - x
        b = 0.0
    } else if x >= 0.8 && x <= 1.0 {
        x = (x - 0.8) / 0.2
        r = 1.0
        g = 0.0
        b = x
    }
    
    return float4(r, g, b, 1.0)
}

func generateColors(number: Int) -> [float4] {
    var colors = [float4](repeating: float4(repeating: 0), count: number)
    for i in 0..<number {
        colors[i] = color(number: (Float(number - i)) / Float(number))
    }
    return colors
}



