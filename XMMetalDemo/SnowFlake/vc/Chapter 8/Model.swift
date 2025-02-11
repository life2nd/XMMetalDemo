//
//  Model.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

class Model: Transformable {
    var transform = Transform()
    var meshes: [Mesh] = []
    var name: String = "Untitled"
    
    init() {
        
    }
    
    init(name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError("Model: \(name) not found !") }
        
        let allocator = MTKMeshBufferAllocator(device: RendererChapter8.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayoutChapter8, bufferAllocator: allocator)
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: RendererChapter8.device)
        meshes = zip(mdlMeshes, mtkMeshes).map{
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        
        self.name = name
    }
}


