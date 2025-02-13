//
//  XMSnowFlakeDemoOneViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import Foundation
import MetalKit

class XMSnowFlakeDemoOneViewController: UIViewController {
    
    var renderer: RendererDemoOne?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "DemoOne"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewDemoOne()
        metalView.frame = view.bounds
        view.addSubview(metalView)
        
        renderer = RendererDemoOne(metalView: metalView)
    }
}

class MetalViewDemoOne: MTKView {
    
}
