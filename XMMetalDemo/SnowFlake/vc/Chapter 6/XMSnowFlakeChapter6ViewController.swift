//
//  XMSnowFlakeChapter6ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/23.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter6ViewController: UIViewController {
    
    var renderer: RendererChapter6?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 6: Coordinate Spaces"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter6()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = RendererChapter6(metalView: metalView)
    }
}

class MetalViewChapter6: MTKView {
    
}
