//
//  modelChapter7.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

import MetalKit

class ModelChapter7: Transformable {
    var transform = Transform()
    let mesh: MTKMesh
    let name: String
    
    init(device: MTLDevice, name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError() }
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayoutChaptor6, bufferAllocator: allocator)
        
        guard let mdlMesh = asset.childObjects(of: MDLMesh.self).first as? MDLMesh else { fatalError() }
        
        do {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch {
            fatalError()
        }
        
        self.name = name
    }
}

extension ModelChapter7 {
    
    func render(encoder: MTLRenderCommandEncoder) {
        
        encoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
        for subMesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(type: .line,
                                          indexCount: subMesh.indexCount,
                                          indexType: subMesh.indexType,
                                          indexBuffer: subMesh.indexBuffer.buffer,
                                          indexBufferOffset: subMesh.indexBuffer.offset)
        }
    }
}
