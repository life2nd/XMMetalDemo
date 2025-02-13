//
//  CameraChapter9.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import MetalKit
import CoreGraphics

protocol CameraChapter9: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    mutating func update(size: CGSize)
    mutating func update(deltaTime: Float)
}

struct FPCameraChapter9: CameraChapter9 {
    var transform: Transform = Transform()
    
    var aspcet: Float = 1.0
    var fov = Float(70).degreesToRadians
    var near: Float = 0.1
    var far: Float = 100
    
    var projectionMatrix: float4x4 {
        float4x4(projectionFov: fov, near: near, far: far, aspect: aspcet)
    }
    mutating func update(size: CGSize) {
        aspcet = Float(size.width) / Float(size.height)
    }
    
    var viewMatrix: float4x4 {
        // 围绕世界坐标旋转
//        (float4x4(rotation: rotation) * float4x4(translation: position)).inverse
        
        // 世界坐标围绕点旋转
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    mutating func update(deltaTime: Float) {
        let transform = updateInpt(deltaTime: deltaTime)
        rotation += transform.rotation
        rotation.x = max(-.pi/2, min(rotation.x, .pi/2))
        
        position += transform.position
    }
}

extension FPCameraChapter9: MovementChapter9 {
    
}


struct OrthographicCameraChapter9: CameraChapter9, MovementChapter9 {
    var transform: Transform = Transform()
    var aspect: CGFloat = 1
    var viewSize: CGFloat = 10
    var near: Float = 0.1
    var far: Float = 100
    
    var viewMatrix: float4x4 {
        (float4x4(translation: position) * float4x4(rotation: rotation)).inverse
    }
    
    var projectionMatrix: float4x4 {
        let rect = CGRect(x: -viewSize * aspect * 0.5, y: viewSize * 0.5, width: viewSize * aspect, height: viewSize)
        return float4x4(orthographic: rect, near: near, far: far)
    }
    
    mutating func update(size: CGSize) {
        aspect = size.width / size.height
    }
    
    mutating func update(deltaTime: Float) {
        let transform = updateInpt(deltaTime: deltaTime)
        position += transform.position
//        let input = InputControllerChapter9.shared
    }
}
