//
//  VertexDescriptorChapter7.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayoutChaptor7: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(.defaultLayoutChaptor7)
    }
}

extension MDLVertexDescriptor {
    static var defaultLayoutChaptor7: MDLVertexDescriptor {
        let vertexDescriptor = MDLVertexDescriptor()
        var offset = 0
        vertexDescriptor.attributes[0] = MDLVertexAttribute(
            name: MDLVertexAttributePosition,
            format: .float3,
            offset: 0,
            bufferIndex: 0)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: offset)
        return vertexDescriptor
    }
}
