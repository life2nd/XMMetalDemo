//
//  GameScene.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

import MetalKit

struct GameSceneChapter9 {
    
    lazy var house: ModelChapter9 = {
        let house = ModelChapter9(name: "lowpoly-house.usdz")
        house.setTexture(name: "barn-color", type: BaseColorChapter9)
        return house
    }()
    
    lazy var ground: ModelChapter9 = {
        let ground = ModelChapter9(name: "ground", primitiveType: .plane)
        ground.setTexture(name: "barn-ground", type: BaseColorChapter9)
        ground.tiling = 16
        ground.transform.scale = 40
        ground.transform.rotation.z = Float(90).degreesToRadians
        return ground
    }()
    
    lazy var models: [ModelChapter9] = [house, ground]
    
    var fpCamera = FPCameraChapter9()
    var ortCamera = OrthographicCameraChapter9()
    
    var camera: CameraChapter9 {
        if InputControllerChapter9.shared.cameraType == .orthoCamera {
            ortCamera
        }
        else {
            fpCamera
        }
    }
    
    init() {
        fpCamera.position = [0, 1.4, -4.0]
        ortCamera.position = [0, 2, 0]
        ortCamera.rotation.x = .pi/2
    }
    
    mutating func update(deltaTime: Float) {
        fpCamera.update(deltaTime: deltaTime)
        ortCamera.update(deltaTime: deltaTime)
    }
    
    mutating func update(size: CGSize) {
        fpCamera.update(size: size)
        ortCamera.update(size: size)
    }
}
