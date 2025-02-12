//
//  Rendering.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/11.
//

import MetalKit

extension Model {
    
    func render(encorder: MTLRenderCommandEncoder, uniforms vertex: UniformsChapter8, params fragment: ParamsChapter8) {
        
        var uniforms = vertex
        var params = fragment

        uniforms.modelMatrix = transform.modelMatrix
        params.tiling = tiling
        
        encorder.setVertexBytes(&uniforms, length: MemoryLayout<UniformsChapter8>.stride, index: UniformsBufferChapter8.index)
        encorder.setFragmentBytes(&params, length: MemoryLayout<ParamsChapter8>.stride, index: ParamsBufferChapter8.index)
        
        for mesh in self.meshes {
            for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                encorder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
            }
            
            for submeshe in mesh.submeshes {
                encorder.setFragmentTexture(submeshe.textures.baseColor, index: BaseColorChapter8.index)
                encorder.drawIndexedPrimitives(type: .triangle,
                                               indexCount: submeshe.indexCount,
                                               indexType: submeshe.indexType,
                                               indexBuffer: submeshe.indexBuffer,
                                               indexBufferOffset: submeshe.indexBufferOffset)
            }
        }
    }
}
