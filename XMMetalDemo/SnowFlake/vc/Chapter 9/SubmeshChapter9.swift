//
//  Submesh.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

struct SubmeshChapter9 {
    let indexCount: Int
    let indexType: MTLIndexType
    let indexBuffer: MTLBuffer
    let indexBufferOffset: Int
    
    struct Textures {
        var baseColor: MTLTexture?
    }
    var textures: Textures
}

extension SubmeshChapter9 {
    init(mdlSubmesh: MDLSubmesh, mtkSubMesh: MTKSubmesh) {
        indexCount = mtkSubMesh.indexCount
        indexType = mtkSubMesh.indexType
        indexBuffer = mtkSubMesh.indexBuffer.buffer
        indexBufferOffset = mtkSubMesh.indexBuffer.offset
        textures = Textures(materail: mdlSubmesh.material)
    }
}

private extension SubmeshChapter9.Textures {
    init(materail: MDLMaterial?) {
        baseColor = materail?.textureChapter9(type: .baseColor)
    }
}

private extension MDLMaterialProperty {
    var textureNameChapter9: String {
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial {
    func textureChapter9(type semantic: MDLMaterialSemantic) -> MTLTexture? {
        if let property = property(with: semantic),
           property.type == MDLMaterialPropertyType.texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return TextureControllerChapter9.loadTexture(texture: mdlTexture, name: property.textureNameChapter9)
        }
        return nil
    }
}
