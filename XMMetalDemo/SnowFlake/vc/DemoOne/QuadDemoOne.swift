//
//  QuadDemoOne.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import Foundation
import MetalKit

struct VertexDemoOne {
    var x: Float
    var y: Float
    var z: Float
}

struct QuadDemoOne {

    var vertices: [VertexDemoOne] = [
        VertexDemoOne(x: -1, y:  1, z: 0),
        VertexDemoOne(x:  1, y: -1, z: 0),
        VertexDemoOne(x: -1, y: -1, z: 0),
        VertexDemoOne(x: -1, y:  1, z: 0),
        VertexDemoOne(x:  1, y:  1, z: 0),
        VertexDemoOne(x:  1, y: -1, z: 0)
    ]
    
    let vertexBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1) {
        vertices = vertices.map {
            VertexDemoOne(x: $0.x * scale, y: $0.y * scale, z: $0.z * scale)
        }
        
        vertexBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<VertexDemoOne>.stride * vertices.count)!
    }
}

