//
//  Primitive.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/11.
//

import MetalKit

enum Primitive {
case plane, sphere
}

extension Model {
    convenience init(name: String, primitiveType: Primitive) {
        let mdlMesh = Self.createMesh(primitiveType: primitiveType)
        mdlMesh.vertexDescriptor = .defaultLayoutChapter8
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: RendererChapter8.device)
        let mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
        self.init()
        self.meshes = [mesh]
        self.name = name
    }
    
    static func createMesh(primitiveType: Primitive) -> MDLMesh {
        let alloctor = MTKMeshBufferAllocator(device: RendererChapter8.device)
        switch primitiveType {
        case .plane:
            return MDLMesh(planeWithExtent: [1, 1, 1], segments: [4, 4], geometryType: .triangles, allocator: alloctor)
        case .sphere:
            return MDLMesh(sphereWithExtent: [1, 1, 1], segments: [30, 30], inwardNormals: false, geometryType: .triangles, allocator: alloctor)
        }
    }
}
