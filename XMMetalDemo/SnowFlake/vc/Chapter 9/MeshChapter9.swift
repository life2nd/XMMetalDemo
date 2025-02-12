//
//  Mesh.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

struct MeshChapter9 {
    var vertexBuffers: [MTLBuffer]
    var submeshes: [SubmeshChapter9]
}

extension MeshChapter9 {
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
        var vertexBuffers: [MTLBuffer] = []
        for mtkMeshBuffer in mtkMesh.vertexBuffers {
            vertexBuffers.append(mtkMeshBuffer.buffer)
        }
        self.vertexBuffers = vertexBuffers
        submeshes = zip(mdlMesh.submeshes!, mtkMesh.submeshes).map { mesh in
            SubmeshChapter9(mdlSubmesh: mesh.0 as! MDLSubmesh, mtkSubMesh: mesh.1)
        }
    }
}
