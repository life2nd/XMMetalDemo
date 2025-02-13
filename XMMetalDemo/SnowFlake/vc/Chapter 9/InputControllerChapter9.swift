//
//  InputControllerChapter9.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import MetalKit

enum InputControllerKeyCode {
case leftArrow, rightArrow, upArrow, downArrow, keyW, keyS, keyA, keyD
}

enum CameraType {
case fpCamera, orthoCamera
}

class InputControllerChapter9 {
    static let shared = InputControllerChapter9()
    
    var cameraType: CameraType = .fpCamera
    
    var keyPressed: Set<InputControllerKeyCode> = []
    
    func inputKeyCodePressed(_ keyCode: InputControllerKeyCode) {
        keyPressed.insert(keyCode)
    }
    
    func inputKeyCodeEndPressed(_ keyCode: InputControllerKeyCode) {
        keyPressed.remove(keyCode)
    }
}
