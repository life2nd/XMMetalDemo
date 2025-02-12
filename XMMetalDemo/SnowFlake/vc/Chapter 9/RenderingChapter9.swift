//
//  Rendering.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/11.
//

import MetalKit

extension ModelChapter9 {
    
    func renderChapter9(encorder: MTLRenderCommandEncoder, uniforms vertex: UniformsChapter9, params fragment: ParamsChapter9) {
        
        var uniforms = vertex
        var params = fragment

        uniforms.modelMatrix = transform.modelMatrix
        params.tiling = tiling
        
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<UniformsChapter9>.stride, index: UniformsBufferChapter9.index)
        encorder.setFragmentBytes(&params, length: MemoryLayout<ParamsChapter9>.stride, index: ParamsBufferChapter9.index)
        
        for mesh in self.meshes {
            for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                encorder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
            }
            
            for submeshe in mesh.submeshes {
                encorder.setFragmentTexture(submeshe.textures.baseColor, index: BaseColorChapter9.index)
                encorder.drawIndexedPrimitives(type: .triangle,
                                               indexCount: submeshe.indexCount,
                                               indexType: submeshe.indexType,
                                               indexBuffer: submeshe.indexBuffer,
                                               indexBufferOffset: submeshe.indexBufferOffset)
            }
        }
    }
}
