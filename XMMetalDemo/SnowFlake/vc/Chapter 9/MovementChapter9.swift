//
//  MovementChapter9.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import Foundation

enum Settings {
    static var rotationSpeed: Float { 2.0 }
    static var translationSpeed: Float { 3.0 }
    static var mouseScrollSensitivity: Float { 0.1 }
    static var mousePanSensitivity: Float { 0.8 }
}

protocol MovementChapter9 where Self: Transformable {
    
}

extension MovementChapter9 {
    func updateInpt(deltaTime: Float) -> Transform {
        var transfom = Transform()
        let rotationAmount = deltaTime * Settings.rotationSpeed
        let input = InputControllerChapter9.shared
        if input.keyPressed.contains(.leftArrow) {
            transfom.rotation.y -= rotationAmount
        }
        if input.keyPressed.contains(.rightArrow) {
            transfom.rotation.y += rotationAmount
        }
        
        var direction: float3 = .zero
        if input.keyPressed.contains(.keyW) {
            direction.z += 1
        }
        if input.keyPressed.contains(.keyS) {
            direction.z -= 1
        }
        if input.keyPressed.contains(.keyA) {
            direction.x -= 1
        }
        if input.keyPressed.contains(.keyD) {
            direction.x += 1
        }
        let translationAmount = deltaTime * Settings.translationSpeed
        if direction != .zero {
            direction = normalize(direction)
            transfom.position += (direction.z * forwardVector + direction.x * rightVector) * translationAmount
        }
        
        return transfom
    }
    
    var forwardVector: float3 {
        normalize([sin(rotation.y), 0, cos(rotation.y)])
    }
    
    var rightVector: float3 {
        [forwardVector.z, forwardVector.y, -forwardVector.x]
    }
}
