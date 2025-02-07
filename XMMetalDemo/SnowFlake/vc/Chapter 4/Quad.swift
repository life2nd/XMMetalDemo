//
//  Quad.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/17.
//

import Foundation
import MetalKit

struct Vertex {
    var x: Float
    var y: Float
    var z: Float
}

struct Quad {

    var vertices: [Vertex] = [
        Vertex(x: -1, y:  1, z: 0),
        Vertex(x:  1, y: -1, z: 0),
        Vertex(x: -1, y: -1, z: 0),
        Vertex(x: -1, y:  1, z: 0),
        Vertex(x:  1, y:  1, z: 0),
        Vertex(x:  1, y: -1, z: 0)
    ]
    
    let vertexBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1) {
        vertices = vertices.map {
            Vertex(x: $0.x * scale, y: $0.y * scale, z: $0.z * scale)
        }
        
        vertexBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<Vertex>.stride * vertices.count)!
    }
}

struct Quad2 {
    
    var vertices: [Vertex] = [
        Vertex(x: -1, y:  1, z: 0),
        Vertex(x:  1, y:  1, z: 0),
        Vertex(x: -1, y: -1, z: 0),
        Vertex(x:  1, y: -1, z: 0)
    ]
    
    var indices: [UInt16] = [
        0, 3, 2,
        0, 1, 3
    ]
    
    var colors: [simd_float3] = [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1],
        [1, 0, 1],
    ]
    
    var pointSize: [Float] = [
        50,
        100,
        150,
        40
    ]
    
    let vertexBuffer: MTLBuffer
    let indicesBuffer: MTLBuffer
    let colorBuffer: MTLBuffer
    let pointSizeBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1) {
        vertices = vertices.map({
            Vertex(x: $0.x * scale, y: $0.y * scale, z: $0.z * scale)
        })
        
        vertexBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<Vertex>.stride * vertices.count)!
        indicesBuffer = device.makeBuffer(bytes: &indices, length: MemoryLayout<UInt16>.stride * indices.count)!
        colorBuffer = device.makeBuffer(bytes: &colors, length: MemoryLayout<simd_float3>.stride * colors.count)!
        pointSizeBuffer = device.makeBuffer(bytes: &pointSize, length: MemoryLayout<Float>.stride * pointSize.count)!
    }
}
