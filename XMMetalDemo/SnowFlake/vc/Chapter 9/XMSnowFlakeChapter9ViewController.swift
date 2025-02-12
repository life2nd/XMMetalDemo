//
//  XMSnowFlakeChapter8ViewController.swift
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/8.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter9ViewController: UIViewController {
    
    var renderer: RendererChapter9?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 9: Navigating a 3D Scene"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter9()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = RendererChapter9(metalView: metalView)
    }
}

class MetalViewChapter9: MTKView {
    
}
