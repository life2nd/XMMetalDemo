//
//  RenderDemoOne.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import Foundation
import MetalKit

class RendererDemoOne: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    
    let timeBuffer: MTLBuffer!
    let resolutionBuffer: MTLBuffer!
    var resolution: float2 = [300, 300]
    private var startTime: TimeInterval
    
    init?(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue()
        else { return nil }
        
        Self.device = device
        Self.commandQueue = commandQueue
        
        timeBuffer = device.makeBuffer(length: MemoryLayout<Float>.size, options: [])!
        resolutionBuffer = device.makeBuffer(length: MemoryLayout<SIMD2<Float>>.size, options: [])!
        
        let library = device.makeDefaultLibrary()!
        Self.library = library
        let vertexFunc = library.makeFunction(name: "vertexMainDemoOne")!
        let fragmentFunc = library.makeFunction(name: "fragmentMainDemoOne")!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            
        }
        
        startTime = CFAbsoluteTimeGetCurrent()
        
        super.init()
        
        metalView.device = device
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        metalView.delegate = self
    }
    
    lazy var quad: QuadDemoOne = {
        QuadDemoOne(device: Self.device, scale: 0.8)
    }()
}

extension RendererDemoOne: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // resolution = [Float(size.width), Float(size.height)]
    }
    
    func draw(in view: MTKView) {
        
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(quad.vertexBuffer, offset: 0, index: 0)
        
        let currentTime = CFAbsoluteTimeGetCurrent() - startTime
        timeBuffer.contents().storeBytes(of: Float(currentTime), as: Float.self)
        resolutionBuffer.contents().storeBytes(of: resolution, as: SIMD2<Float>.self)
        
        renderEncoder.setFragmentBuffer(timeBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(resolutionBuffer, offset: 0, index: 1)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: quad.vertices.count)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

