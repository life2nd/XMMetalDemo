//
//  TextureController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/12.
//

import MetalKit

enum TextureControllerChapter9 {
    
    static var textures: [String: MTLTexture] = [:]
    
    static func loadTexture(texture: MDLTexture, name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: RendererChapter9.device)
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [.origin: MTKTextureLoader.Origin.bottomLeft,
                                                                    .generateMipmaps: true]
        let texture = try? textureLoader.newTexture(texture: texture, options: textureLoaderOptions)
        print("loaded texture from USD: \(name) file")
        textures[name] = texture
        return texture
    }
    
    static func loadTexture(name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }
        
        let textureLoader = MTKTextureLoader(device: RendererChapter9.device)
        let texture: MTLTexture?
        texture = try? textureLoader.newTexture(name: name, scaleFactor: 1.0, bundle: Bundle.main, options: nil)
        if texture != nil {
            print("loaded texture: \(name)")
            textures[name] = texture
        }
        return texture
    }
}
