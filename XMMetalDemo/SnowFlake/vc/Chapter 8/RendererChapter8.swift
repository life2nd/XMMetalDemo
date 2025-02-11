//
//  Renderer.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

class RendererChapter8: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState?
    
    lazy var house: Model = {
       Model(name: "lowpoly-house.usdz")
    }()
    
    var timer: Float = 0
    var uniforms = UniformsChapter8()
    var params = ParamsChapter8()
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else { fatalError() }
        
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunc = library?.makeFunction(name: "vertex_mainChapter8")
        let fragmentFunc = library?.makeFunction(name: "fragemnt_mainChapter8")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = .defaultLayoutChapter8
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        depthStencilState = RendererChapter8.buildDepthStencilState()
        super.init()
        
        metalView.clearColor = MTLClearColor(red: 0.93, green: 0.97, blue: 1.0, alpha: 1.0)
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true
        return RendererChapter8.device.makeDepthStencilState(descriptor: depthDescriptor)
    }
}

extension RendererChapter8: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect = Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(70).degreesToRadians, near: 0.1, far: 100, aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
        
        params.width = uint(size.width)
        params.height = uint(size.height)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = RendererChapter8.commandQueue.makeCommandBuffer(),
        let descriptor = view.currentRenderPassDescriptor,
        let renderEncorder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        timer += 0.005
        uniforms.viewMatrix = float4x4(translation: [0, 1.4, -4.0]).inverse
        
        renderEncorder.setDepthStencilState(depthStencilState)
        renderEncorder.setRenderPipelineState(pipelineState)
        
        house.rotation.y = sin(timer)
        house.render(encorder: renderEncorder, uniforms: uniforms, params: params)
        
        renderEncorder.endEncoding()
        
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
