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
    
    lazy var leftCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var rightCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var upCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var downCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var wCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var aCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var sCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    lazy var dCtrl: XMControlEvent = {
        let ctrl = XMControlEvent()
        return ctrl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chapter 9: Navigating a 3D Scene"
        view.backgroundColor = .systemBackground
        
        build()
        buildCtrl()
    }
    
    private func build() {
        let metalView = MetalViewChapter9()
//        let frame = CGRect(x: (view.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 300)
//        metalView.frame = frame
        metalView.frame = view.bounds
        view.addSubview(metalView)
        
        renderer = RendererChapter9(metalView: metalView)
    }
    
    private func buildCtrl() {
        view.addSubview(leftCtrl)
        view.addSubview(rightCtrl)
        view.addSubview(upCtrl)
        view.addSubview(downCtrl)
        view.addSubview(wCtrl)
        view.addSubview(aCtrl)
        view.addSubview(sCtrl)
        view.addSubview(dCtrl)
        
        leftCtrl.setIconImage(UIImage(systemName: "arrowshape.left.fill")!)
        rightCtrl.setIconImage(UIImage(systemName: "arrowshape.right.fill")!)
        upCtrl.setIconImage(UIImage(systemName: "arrowshape.up.fill")!)
        downCtrl.setIconImage(UIImage(systemName: "arrowshape.down.fill")!)
        wCtrl.setIconImage(UIImage(systemName: "arrowshape.up.fill")!)
        aCtrl.setIconImage(UIImage(systemName: "arrowshape.left.fill")!)
        dCtrl.setIconImage(UIImage(systemName: "arrowshape.right.fill")!)
        sCtrl.setIconImage(UIImage(systemName: "arrowshape.down.fill")!)
        
        leftCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .leftArrow)
        }
        rightCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .rightArrow)
        }
        upCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .upArrow)
        }
        downCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .downArrow)
        }
        wCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .keyW)
        }
        aCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .keyA)
        }
        sCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .keyS)
        }
        dCtrl.touchHandler = { [weak self] action in
            self?.handleAction(action, keyCode: .keyD)
        }
        
        NSLayoutConstraint.activate([
            rightCtrl.widthAnchor.constraint(equalToConstant: 50),
            rightCtrl.heightAnchor.constraint(equalToConstant: 50),
            rightCtrl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            rightCtrl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            leftCtrl.widthAnchor.constraint(equalTo: rightCtrl.widthAnchor),
            leftCtrl.heightAnchor.constraint(equalTo: rightCtrl.heightAnchor),
            leftCtrl.rightAnchor.constraint(equalTo: rightCtrl.leftAnchor, constant: -50),
            leftCtrl.centerYAnchor.constraint(equalTo: rightCtrl.centerYAnchor),
            
            upCtrl.widthAnchor.constraint(equalToConstant: 50),
            upCtrl.heightAnchor.constraint(equalToConstant: 50),
            upCtrl.bottomAnchor.constraint(equalTo: rightCtrl.topAnchor),
            upCtrl.rightAnchor.constraint(equalTo: rightCtrl.leftAnchor),
            
            downCtrl.widthAnchor.constraint(equalTo: upCtrl.widthAnchor),
            downCtrl.heightAnchor.constraint(equalTo: upCtrl.heightAnchor),
            downCtrl.centerXAnchor.constraint(equalTo: upCtrl.centerXAnchor),
            downCtrl.topAnchor.constraint(equalTo: upCtrl.bottomAnchor, constant: 50),
            
            aCtrl.widthAnchor.constraint(equalToConstant: 50),
            aCtrl.heightAnchor.constraint(equalToConstant: 50),
            aCtrl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            aCtrl.centerYAnchor.constraint(equalTo: rightCtrl.centerYAnchor),
            
            dCtrl.widthAnchor.constraint(equalTo: aCtrl.widthAnchor),
            dCtrl.heightAnchor.constraint(equalTo: aCtrl.heightAnchor),
            dCtrl.leftAnchor.constraint(equalTo: aCtrl.rightAnchor, constant: 50),
            dCtrl.centerYAnchor.constraint(equalTo: aCtrl.centerYAnchor),
            
            wCtrl.widthAnchor.constraint(equalToConstant: 50),
            wCtrl.heightAnchor.constraint(equalToConstant: 50),
            wCtrl.leftAnchor.constraint(equalTo: aCtrl.rightAnchor, constant: 0),
            wCtrl.bottomAnchor.constraint(equalTo: aCtrl.topAnchor, constant: 0),
            
            sCtrl.widthAnchor.constraint(equalTo: wCtrl.widthAnchor),
            sCtrl.heightAnchor.constraint(equalTo: wCtrl.heightAnchor),
            sCtrl.centerXAnchor.constraint(equalTo: wCtrl.centerXAnchor),
            sCtrl.topAnchor.constraint(equalTo: wCtrl.bottomAnchor, constant: 50)
            
        ])
    }
    
    func handleAction(_ action: String, keyCode: InputControllerKeyCode) {
        print("action: \(action), keyCode: \(keyCode)")
        
        if action == "Begin" {
            InputControllerChapter9.shared.inputKeyCodePressed(keyCode)
        }
        else {
            InputControllerChapter9.shared.inputKeyCodeEndPressed(keyCode)
        }
    }
}

class XMControlEvent: UIControl {
    
    var touchHandler: ((String) -> Void)?
    
    lazy var imageView: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIconImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touchHandler {
            touch("Begin")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touchHandler {
            touch("End")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touchHandler {
            touch("Cancel")
        }
    }
}

class MetalViewChapter9: MTKView {
    
}
