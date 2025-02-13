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
    
    var camera = FPCameraChapter9()
    
    init() {
        camera.position = [0, 1.4, -4.0]
    }
    
    mutating func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
    }
    
    mutating func update(size: CGSize) {
        camera.update(size: size)
    }
}
