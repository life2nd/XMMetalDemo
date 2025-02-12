//
//  Model.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

class ModelChapter9: Transformable {
    var transform = Transform()
    var meshes: [MeshChapter9] = []
    var name: String = "Untitled"
    var tiling: UInt32 = 1
    
    init() {
        
    }
    
    init(name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else { fatalError("Model: \(name) not found !") }
        
        let allocator = MTKMeshBufferAllocator(device: RendererChapter9.device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .defaultLayoutChapter9, bufferAllocator: allocator)
        asset.loadTextures()
        let (mdlMeshes, mtkMeshes) = try! MTKMesh.newMeshes(asset: asset, device: RendererChapter9.device)
        meshes = zip(mdlMeshes, mtkMeshes).map{
            MeshChapter9(mdlMesh: $0.0, mtkMesh: $0.1)
        }
        
        self.name = name
    }
}

extension ModelChapter9 {
    func setTexture(name: String, type: TextureIndicesChapter9) {
        if let texture = TextureControllerChapter9.loadTexture(name: name) {
            switch type {
            case BaseColorChapter9:
                meshes[0].submeshes[0].textures.baseColor = texture
            default:
                break
            }
        }
    }
}
