//
//  Renderer.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

import MetalKit

class RendererChapter9: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState?
    
    lazy var scene = GameSceneChapter9()
    
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    var uniforms = UniformsChapter9()
    var params = ParamsChapter9()
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(), let commandQueue = device.makeCommandQueue() else { fatalError() }
        
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunc = library?.makeFunction(name: "vertex_mainChapter9")
        let fragmentFunc = library?.makeFunction(name: "fragemnt_mainChapter9")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = .defaultLayoutChapter9
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        depthStencilState = RendererChapter9.buildDepthStencilState()
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
        return RendererChapter9.device.makeDepthStencilState(descriptor: depthDescriptor)
    }
}

extension RendererChapter9: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
        
        params.width = uint(size.width)
        params.height = uint(size.height)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = RendererChapter9.commandQueue.makeCommandBuffer(),
        let descriptor = view.currentRenderPassDescriptor,
        let renderEncorder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        renderEncorder.setDepthStencilState(depthStencilState)
        renderEncorder.setRenderPipelineState(pipelineState)
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = Float(currentTime - lastTime)
        lastTime = currentTime
        scene.update(deltaTime: deltaTime)
        
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        
        for model in scene.models {
            model.renderChapter9(encorder: renderEncorder, uniforms: uniforms, params: params)
        }
        
        renderEncorder.endEncoding()
        
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
