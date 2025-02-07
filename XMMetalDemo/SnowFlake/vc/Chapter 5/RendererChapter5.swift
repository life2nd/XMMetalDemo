//
//  RendererChapter5.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/20.
//

import Foundation
import MetalKit

class RendererChapter5: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var indicesBuffer: MTLBuffer!
    
    init(metalView: MTKView) {
        Self.device = MTLCreateSystemDefaultDevice()
        Self.commandQueue = Self.device.makeCommandQueue()
        Self.library = Self.device.makeDefaultLibrary()
        
        super.init()
        
        metalView.device = Self.device
        metalView.delegate = self
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        
        build(metalView)
    }
    
    lazy var triangel: Triangle = {
        Triangle(device: Self.device)
    }()
    
    private func build(_ metalView: MTKView) {
        guard let device = Self.device, let library = Self.library else { return }
        
        let vertexFunc = library.makeFunction(name: "vertexMainChapter5")!
        let fragmentFunc = library.makeFunction(name: "fragmentMainChapter5")!
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexFunc
        pipelineStateDescriptor.fragmentFunction = fragmentFunc
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        vertexBuffer = triangel.vertexBuffer
        indicesBuffer = triangel.indicesBuffer
    }
}

extension RendererChapter5: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }

        let commandBuffer = Self.commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(indicesBuffer, offset: 0, index: 1)
        
        // 直接的方式
        /*
        renderEncoder.drawPrimitives(type: .triangle,
                                   vertexStart: 0, 
                                   vertexCount: triangel.vertices.count / 3)  // 每个顶点3个浮点数
         */
        
        // 走缓存的方式
        var color: [Float] = [0.8, 0.8, 0.8, 1]
        renderEncoder.setVertexBytes(color, length: MemoryLayout<Float>.stride * color.count, index: 2)
        var maxtrix = simd_float4x4(diagonal: [1, 1, 1, 1])
        renderEncoder.setVertexBytes(&maxtrix, length: MemoryLayout<simd_float4x4>.stride, index: 3)
//        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: triangel.indices.count)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: triangel.indices.count, indexType: .uint16, indexBuffer: indicesBuffer, indexBufferOffset: 0)
        
        // 绘制第二个
        let positionMaxtrix: simd_float4x4 = simd_float4x4([1, 0, 0, 0],
                                                           [0, 1, 0, 0],
                                                           [0, 0, 1, 0],
                                                           [0.4, 0.1, 0, 1])
        let scaleMaxtrix: simd_float4x4 = simd_float4x4([0.75, 0, 0, 0],
                                                        [0, 0.75, 0, 0],
                                                        [0, 0, 1, 0],
                                                        [0, 0, 0, 1])
        let rotateMaxtrix: simd_float4x4 = simd_float4x4([cos(-Float.pi/2.0), sin(-Float.pi/2.0), 0, 0],
                                                         [-sin(-Float.pi/2.0), cos(-Float.pi/2.0), 0, 0],
                                                         [0, 0, 1, 0],
                                                         [0, 0, 0, 1])
        maxtrix = positionMaxtrix * rotateMaxtrix * scaleMaxtrix * positionMaxtrix.inverse * maxtrix
        color = [1.0, 0.0, 0.0, 1]
        renderEncoder.setVertexBytes(color, length: MemoryLayout<Float>.stride * color.count, index: 2)
        renderEncoder.setVertexBytes(&maxtrix, length: MemoryLayout<simd_float4x4>.stride, index: 3)
//        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: triangel.indices.count)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: triangel.indices.count, indexType: .uint16, indexBuffer: indicesBuffer, indexBufferOffset: 0)
        
        
        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}
