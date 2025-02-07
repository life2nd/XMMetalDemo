//
//  XMSnowFlakeChapter5ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/20.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter5ViewController: UIViewController {
    
    var renderer: RendererChapter5?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 5: 3D Transformations"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter5()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = RendererChapter5(metalView: metalView)
    }
}


class MetalViewChapter5: MTKView {
    
}
