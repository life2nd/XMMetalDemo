//
//  InputControllerChapter9.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import MetalKit

enum InputControllerKeyCode {
case leftArrow, rightArrow, keyW, keyS, keyA, keyD
}

class InputControllerChapter9 {
    static let shared = InputControllerChapter9()
    
    var keyPressed: Set<InputControllerKeyCode> = []
    
    func inputKeyCodePressed(_ keyCode: InputControllerKeyCode) {
        keyPressed.insert(keyCode)
    }
    
    func inputKeyCodeEndPressed(_ keyCode: InputControllerKeyCode) {
        keyPressed.remove(keyCode)
    }
}
