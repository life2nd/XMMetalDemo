//
//  Primitive.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/11.
//

import MetalKit

enum PrimitiveChapter9 {
case plane, sphere
}

extension ModelChapter9 {
    convenience init(name: String, primitiveType: PrimitiveChapter9) {
        let mdlMesh = Self.createMesh(primitiveType: primitiveType)
        mdlMesh.vertexDescriptor = .defaultLayoutChapter9
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: RendererChapter9.device)
        let mesh = MeshChapter9(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
        self.init()
        self.meshes = [mesh]
        self.name = name
    }
    
    static func createMesh(primitiveType: PrimitiveChapter9) -> MDLMesh {
        let alloctor = MTKMeshBufferAllocator(device: RendererChapter9.device)
        switch primitiveType {
        case .plane:
            return MDLMesh(planeWithExtent: [1, 1, 1], segments: [4, 4], geometryType: .triangles, allocator: alloctor)
        case .sphere:
            return MDLMesh(sphereWithExtent: [1, 1, 1], segments: [30, 30], inwardNormals: false, geometryType: .triangles, allocator: alloctor)
        }
    }
}
