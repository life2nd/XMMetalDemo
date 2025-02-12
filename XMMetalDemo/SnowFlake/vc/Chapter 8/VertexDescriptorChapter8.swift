//
//  VertexDescriptorChapter8.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/11.
//

import MetalKit

extension MTLVertexDescriptor {
    static var defaultLayoutChapter8: MTLVertexDescriptor? {
        MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.defaultLayoutChapter8)
    }
}

extension MDLVertexDescriptor {
    static var defaultLayoutChapter8: MDLVertexDescriptor {
        let vertexDescriptor = MDLVertexDescriptor()
        var offset = 0
        
        vertexDescriptor.attributes[PositionChapter8.index] = MDLVertexAttribute(name: MDLVertexAttributePosition,
                                                                                 format: .float3,
                                                                                 offset: offset,
                                                                                 bufferIndex: VertexBufferChapter8.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.attributes[NormalChapter8.index] = MDLVertexAttribute(name: MDLVertexAttributeNormal,
                                                                               format: .float3,
                                                                               offset: offset,
                                                                               bufferIndex: VertexBufferChapter8.index)
        offset += MemoryLayout<float3>.stride
        vertexDescriptor.layouts[VertexBufferChapter8.index] = MDLVertexBufferLayout(stride: offset)
        
        vertexDescriptor.attributes[UVChapter8.index] = MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate, 
                                                                           format: .float2,
                                                                           offset: 0,
                                                                           bufferIndex: UVBufferChapter8.index)
        vertexDescriptor.layouts[UVBufferChapter8.index] = MDLVertexBufferLayout(stride: MemoryLayout<float2>.stride)
        
        return vertexDescriptor
    }
}

extension AttributesChapter8 {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension BufferIndicesChapter8 {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension TextureIndicesChapter8 {
    var index: Int {
        return Int(self.rawValue)
    }
}
