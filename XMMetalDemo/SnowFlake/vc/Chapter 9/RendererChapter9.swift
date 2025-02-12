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
    
    lazy var house: ModelChapter9 = {
        let house = ModelChapter9(name: "lowpoly-house.usdz")
        house.setTexture(name: "barn-color", type: BaseColorChapter9)
        return house
    }()
    
    lazy var ground: ModelChapter9 = {
        let ground = ModelChapter9(name: "ground", primitiveType: .plane)
        ground.setTexture(name: "barn-ground", type: BaseColorChapter9)
        ground.tiling = 16
        return ground
    }()
    
    var timer: Float = 0
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
        let aspect = Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(70).degreesToRadians, near: 0.1, far: 100, aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
        
        params.width = uint(size.width)
        params.height = uint(size.height)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = RendererChapter9.commandQueue.makeCommandBuffer(),
        let descriptor = view.currentRenderPassDescriptor,
        let renderEncorder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        timer += 0.005
        uniforms.viewMatrix = float4x4(translation: [0, 1.4, -4.0]).inverse
        
        renderEncorder.setDepthStencilState(depthStencilState)
        renderEncorder.setRenderPipelineState(pipelineState)
        
        house.rotation.y = sin(timer)
        house.renderChapter9(encorder: renderEncorder, uniforms: uniforms, params: params)
        
        ground.scale = 40
        ground.rotation.z = Float(90).degreesToRadians
        ground.rotation.y = sin(timer)
        ground.renderChapter9(encorder: renderEncorder, uniforms: uniforms, params: params)
        
        renderEncorder.endEncoding()
        
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
