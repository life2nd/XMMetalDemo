//
//  XMSnowFlakeChapter4ViewController.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/17.
//

import Foundation
import MetalKit

class XMSnowFlakeChapter4ViewController: UIViewController {
    
    var renderer: RendererChapter4?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 4: The Vertex Function"
        view.backgroundColor = .systemBackground
        
        build()
    }
    
    private func build() {
        let metalView = MetalViewChapter4()
        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
        metalView.frame = frame
        view.addSubview(metalView)
        
        renderer = RendererChapter4(metalView: metalView)
    }
}


class MetalViewChapter4: MTKView {
    
}
