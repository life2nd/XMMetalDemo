//
//  XMSnowFlakeChapter3ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/16.
//

import UIKit
import MetalKit

class XMSnowFlakeChapter3ViewController: UIViewController {
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 3: The Rendering Pipeline !"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalView()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = Renderer(metalView: metalView)
    }
}


class MetalView: MTKView {
    
}
