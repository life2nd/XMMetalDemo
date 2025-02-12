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
    var tiling: UInt32 = 1
    
    init() {
        
    }
    
    init(name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError("Model: \(name) not found !") }
        
        let allocator = MTKMeshBufferAllocator(device: RendererChapter8.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayoutChapter8, bufferAllocator: allocator)
        asset.loadTextures()
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: RendererChapter8.device)
        meshes = zip(mdlMeshes, mtkMeshes).map{
            Mesh(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        
        self.name = name
    }
}

extension Model {
    func setTexture(name: String, type: TextureIndicesChapter8) {
        if let texture = TextureController.loadTexture(name: name) {
            switch type {
            case BaseColorChapter8:
                meshes[0].submeshes[0].textures.baseColor = texture
            default:
                break
            }
        }
    }
}
