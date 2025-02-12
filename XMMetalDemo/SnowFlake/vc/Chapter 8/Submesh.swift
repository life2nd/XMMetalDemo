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
    
    struct Textures {
        var baseColor: MTLTexture?
    }
    var textures: Textures
}

extension Submesh {
    init(mdlSubmesh: MDLSubmesh, mtkSubMesh: MTKSubmesh) {
        indexCount = mtkSubMesh.indexCount
        indexType = mtkSubMesh.indexType
        indexBuffer = mtkSubMesh.indexBuffer.buffer
        indexBufferOffset = mtkSubMesh.indexBuffer.offset
        textures = Textures(materail: mdlSubmesh.material)
    }
}

private extension Submesh.Textures {
    init(materail: MDLMaterial?) {
        baseColor = materail?.texture(type: .baseColor)
    }
}

private extension MDLMaterialProperty {
    var textureName: String {
        stringValue ?? UUID().uuidString
    }
}

private extension MDLMaterial {
    func texture(type semantic: MDLMaterialSemantic) -> MTLTexture? {
        if let property = property(with: semantic),
           property.type == MDLMaterialPropertyType.texture,
           let mdlTexture = property.textureSamplerValue?.texture {
            return TextureController.loadTexture(texture: mdlTexture, name: property.textureName)
        }
        return nil
    }
}
