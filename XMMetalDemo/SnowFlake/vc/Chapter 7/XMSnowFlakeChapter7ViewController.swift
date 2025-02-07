//
//  XMSnowFlakeChapter7ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter7ViewController: UIViewController {
    
    var renderer: RendererChapter7?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 7: The Fragment Function"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter7()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = RendererChapter7(metalView: metalView)
    }
}

class MetalViewChapter7: MTKView {
    
}

