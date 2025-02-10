//
//  XMSnowFlakeChapter8ViewController.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/8.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter8ViewController: UIViewController {
    
//    var renderer: RendererChapter8?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 8: Textures"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter8()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
//        renderer = RendererChapter8(metalView: metalView)
    }
}

class MetalViewChapter8: MTKView {
    
}
