//
//  RendererChapter7.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

import MetalKit

class RendererChapter7: NSObject {
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState: MTLRenderPipelineState!
    
    lazy var model: ModelChapter7 = {
        ModelChapter7(device: Renderer.device, name: "train.usd")
    }()
    
    var timer: Float = 0
    var uniform = UniformsChapter7()
    var params = ParamsChatper7()
    let depthStencilState: MTLDepthStencilState?
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue()
        else { fatalError() }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        metalView.device = device
        metalView.depthStencilPixelFormat = .depth32Float
        
        let library = device.makeDefaultLibrary()
        Self.library = library
        let vertexFunc = library?.makeFunction(name: "vertex_mainChapter7")
        let fragmentFunc = library?.makeFunction(name: "fragment_mainChapter7")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.vertexDescriptor = .defaultLayoutChaptor7
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError()
        }
        
        self.depthStencilState = Self.buildDepthStencilState()
        super.init()
        
        metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        metalView.delegate = self
        
        uniform.viewMatrix = float4x4(translation: [0.8, 0, 0]).inverse
        
        params.screenScale = uint(UIScreen.main.scale)
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let depthStencilStateDescriptor = MTLDepthStencilDescriptor()
        depthStencilStateDescriptor.depthCompareFunction = .less
        depthStencilStateDescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: depthStencilStateDescriptor)
    }
}

extension RendererChapter7: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect = Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(70).degreesToRadians,
                                        near: 0.1,
                                        far: 100,
                                        aspect: aspect)
        uniform.projectionMatrix = projectionMatrix
        
        params.width = uint(size.width)
        params.height = uint(size.height)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
        let descriptor = view.currentRenderPassDescriptor,
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        
        timer += 0.005
        uniform.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
        
        model.position.y = -0.6
        model.rotation.y = sin(timer)
        uniform.modelMatrix = model.transform.modelMatrix
        
        renderEncoder.setVertexBytes(&uniform, length: MemoryLayout<UniformsChapter7>.stride, index: 11)
        renderEncoder.setFragmentBytes(&params, length: MemoryLayout<ParamsChatper7>.stride, index: 12)
        
        model.render(encoder: renderEncoder)
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

