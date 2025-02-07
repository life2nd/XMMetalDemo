//
//  XMSnowFlakeChapter2ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/15.
//

import UIKit
import MetalKit

class XMSnowFlakeChapter2ViewController: UIViewController {
    
    // Metal设备，代表GPU
    private var device: MTLDevice?
    // 命令队列，用于向GPU发送命令
    private var commandQueue: MTLCommandQueue?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 2: 3D Models !"
        view.backgroundColor = .systemBackground
        
        build()
    }

    private func build() {
        // 获取默认的Metal设备（GPU）
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        self.device = device
        
        // 创建Metal视图并设置基本属性
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        let view = MTKView(frame: frame, device: device)
        view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
        self.view.addSubview(view)
        
        // 创建网格分配器和球体网格
        let allocator = MTKMeshBufferAllocator(device: device)
        // 载入train的usdz模型
        guard let assetURL = Bundle.main.url(forResource: "train", withExtension: "usd") else { return }
        
        // 创建顶点描述符
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset = MDLAsset(url: assetURL, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        let mdlMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        // 将MDLMesh转换为MTKMesh，这样Metal才能使用
        guard let mesh = try? MTKMesh(mesh: mdlMesh, device: device) else { return }
        
        // 创建命令队列
        guard let commandQueue = device.makeCommandQueue() else { return }
        self.commandQueue = commandQueue
        
        // 加载着色器函数
        guard let library = device.makeDefaultLibrary(),
              let vertexFunc = library.makeFunction(name: "vertexMainChapter2"),
              let fragmentFunc = library.makeFunction(name: "fragmentMainChapter2")
        else { return }
        
        // 设置渲染管线描述符
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        // 设置顶点描述符，告诉Metal如何解释顶点数据
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        
        // 创建渲染管线状态
        guard let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor) else { return }
        
        // 创建命令缓冲区和编码器
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        else { return }
        
        // 设置渲染管线状态
        commandEncoder.setRenderPipelineState(pipelineState)
        
        // 设置顶点缓冲区
        // index 0 对应着色器中的 [[buffer(0)]]
        // mesh.vertexBuffers[0].buffer 包含了顶点位置、法线等数据
        commandEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
        // 绘制网格
        for subMesh in mesh.submeshes {
            // 使用索引绘制三角形
            // indexCount: 索引的数量
            // indexType: 索引的类型（通常是16位或32位整数）
            // indexBuffer: 存储索引的缓冲区
            commandEncoder.drawIndexedPrimitives(type: .line,
                                                 indexCount: subMesh.indexCount,
                                                 indexType: subMesh.indexType,
                                                 indexBuffer: subMesh.indexBuffer.buffer,
                                                 indexBufferOffset: subMesh.indexBuffer.offset)
        }
        
        // 结束编码并提交命令
        commandEncoder.endEncoding()
        
        // 获取可绘制纹理并呈现
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

