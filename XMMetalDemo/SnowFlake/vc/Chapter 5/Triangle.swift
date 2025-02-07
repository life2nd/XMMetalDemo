//
//  Trigger.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/20.
//

import Foundation
import MetalKit

struct Triangle {
    
    var vertices: [Float] = [
        -0.7, 0.8, 0,
        -0.7, -0.5, 0,
        0.4, 0.1, 0
    ]
    
    var indices: [UInt16] = [
        0, 1, 2
    ]
    
    let vertexBuffer: MTLBuffer
    let indicesBuffer: MTLBuffer
    
    init(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<Float>.stride * vertices.count)!
        indicesBuffer = device.makeBuffer(bytes: &indices, length: MemoryLayout<UInt16>.stride * indices.count)!
    }
}
