//
//  Submesh.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

struct Submesh {
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubMesh: MTKSubmesh) {
        indexCount = mtkSubMesh.indexCount
        indexType = mtkSubMesh.indexType
        indexBuffer = mtkSubMesh.indexBuffer.buffer
        indexBufferOffset = mtkSubMesh.indexBuffer.offset
    }
}
