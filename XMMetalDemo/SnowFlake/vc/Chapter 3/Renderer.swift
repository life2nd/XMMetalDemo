//
//  Renderer.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/17.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    init?(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue()
        else { return nil }
        
        Self.device = device
        Self.commandQueue = commandQueue
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let mdlMesh = MDLMesh(boxWithExtent: [0.75, 0.75, 0.75], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        mesh = try! MTKMesh(mesh: mdlMesh, device: device)
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        let library = device.makeDefaultLibrary()!
        Self.library = library
        let vertexFunc = library.makeFunction(name: "vertexMainChapter3")!
        let fragmentFunc = library.makeFunction(name: "fragmentMainChapter3")!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            
        }
        
        super.init()
        
        metalView.device = device
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        for subMesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: subMesh.indexCount,
                                                indexType: subMesh.indexType,
                                                indexBuffer: subMesh.indexBuffer.buffer,
                                                indexBufferOffset: subMesh.indexBuffer.offset)
        }
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
