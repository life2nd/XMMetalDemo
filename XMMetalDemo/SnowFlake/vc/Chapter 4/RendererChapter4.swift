//
//  Renderer4.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/17.
//

import Foundation
import MetalKit

class RendererChapter4: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    var pipelineStatePart2: MTLRenderPipelineState!
    var pipelineStatePart3: MTLRenderPipelineState!
    var pipelineStatePart4: MTLRenderPipelineState!
    var pipelineStatePart5: MTLRenderPipelineState!
    var timer: Float = 0
    
    init?(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue()
        else { return nil }
        
        Self.device = device
        Self.commandQueue = commandQueue
        
        let library = device.makeDefaultLibrary()!
        Self.library = library
        let vertexFunc = library.makeFunction(name: "vertexMainChapter4")!
        let fragmentFunc = library.makeFunction(name: "fragmentMainChapter4")!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            
        }
        
        let pipelineDescriptorPart2 = MTLRenderPipelineDescriptor()
        pipelineDescriptorPart2.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptorPart2.vertexFunction = library.makeFunction(name: "vertexMainChapter4Part2")!
        pipelineDescriptorPart2.fragmentFunction = library.makeFunction(name: "fragmentMainChapter4Part2")
        pipelineStatePart2 = try! device.makeRenderPipelineState(descriptor: pipelineDescriptorPart2)
        
        let pipelineDescriptorPart3 = MTLRenderPipelineDescriptor()
        pipelineDescriptorPart3.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptorPart3.vertexFunction = library.makeFunction(name: "vertexMainChapter4Part3")!
        pipelineDescriptorPart3.fragmentFunction = library.makeFunction(name: "fragmentMainChapter4Part3")
        pipelineDescriptorPart3.vertexDescriptor = .defaultLayout
        pipelineStatePart3 = try! device.makeRenderPipelineState(descriptor: pipelineDescriptorPart3)
        
        let pipelineDescriptorPart4 = MTLRenderPipelineDescriptor()
        pipelineDescriptorPart4.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptorPart4.vertexFunction = library.makeFunction(name: "vertexMainChapter4Part4")!
        pipelineDescriptorPart4.fragmentFunction = library.makeFunction(name: "fragmentMainChapter4Part4")
        let vertexDescriptorPart4 = MTLVertexDescriptor.defaultLayout
        vertexDescriptorPart4.attributes[1].format = .float3
        vertexDescriptorPart4.attributes[1].offset = 0
        vertexDescriptorPart4.attributes[1].bufferIndex = 1
        vertexDescriptorPart4.layouts[1].stride = MemoryLayout<simd_float3>.stride
        pipelineDescriptorPart4.vertexDescriptor = vertexDescriptorPart4
        pipelineStatePart4 = try! device.makeRenderPipelineState(descriptor: pipelineDescriptorPart4)
        
        let pipelineDescriptorPart5 = MTLRenderPipelineDescriptor()
        pipelineDescriptorPart5.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptorPart5.vertexFunction = library.makeFunction(name: "vertexMainChapter4Part5")!
        pipelineDescriptorPart5.fragmentFunction = library.makeFunction(name: "fragmentMainChapter4Part5")
        let vertexDescriptorPart5 = MTLVertexDescriptor.defaultLayout
        vertexDescriptorPart5.attributes[1].format = .float3
        vertexDescriptorPart5.attributes[1].offset = 0
        vertexDescriptorPart5.attributes[1].bufferIndex = 1
        vertexDescriptorPart5.layouts[1].stride = MemoryLayout<simd_float3>.stride
        vertexDescriptorPart5.attributes[2].format = .float
        vertexDescriptorPart5.attributes[2].offset = 0
        vertexDescriptorPart5.attributes[2].bufferIndex = 2
        vertexDescriptorPart5.layouts[2].stride = MemoryLayout<Float>.stride
        pipelineDescriptorPart5.vertexDescriptor = vertexDescriptorPart5
        pipelineStatePart5 = try! device.makeRenderPipelineState(descriptor: pipelineDescriptorPart5)
        
        super.init()
        
        metalView.device = device
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
    }
    
    lazy var quad: Quad = {
        Quad(device: Self.device, scale: 0.8)
    }()
    
    lazy var quad2: Quad2 = {
        Quad2(device: Self.device, scale: 0.8)
    }()
}

extension RendererChapter4: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        timer += 0.005
        var currentTime = sin(timer)
        
        /* Part1的方式
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11)
        renderEncoder.setVertexBuffer(quad.vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: quad.vertices.count)
         */
        
        // Part2的方式
        /*
        renderEncoder.setRenderPipelineState(pipelineStatePart2)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11)
        renderEncoder.setVertexBuffer(quad2.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(quad2.indicesBuffer, offset: 0, index: 1)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: quad2.indices.count)
         */
        
        // Part3的方式
        /*
        renderEncoder.setRenderPipelineState(pipelineStatePart3)
        renderEncoder.setVertexBuffer(quad2.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: quad2.indices.count, indexType: .uint16, indexBuffer: quad2.indicesBuffer, indexBufferOffset: 0)
         */
        
        // Part4的方式
        /*
        renderEncoder.setRenderPipelineState(pipelineStatePart4)
        renderEncoder.setVertexBuffer(quad2.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(quad2.colorBuffer, offset: 0, index: 1)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11)
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: quad2.indices.count, indexType: .uint16, indexBuffer: quad2.indicesBuffer, indexBufferOffset: 0)
         */
        
        // Part5的方式
        renderEncoder.setRenderPipelineState(pipelineStatePart5)
        renderEncoder.setVertexBuffer(quad2.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(quad2.colorBuffer, offset: 0, index: 1)
        renderEncoder.setVertexBuffer(quad2.pointSizeBuffer, offset: 0, index: 2)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 11)
        renderEncoder.drawIndexedPrimitives(type: .point, indexCount: quad2.indices.count, indexType: .uint16, indexBuffer: quad2.indicesBuffer, indexBufferOffset: 0)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

