//
//  MathLibrary.swift
//  XMMetalDemo
//
//  Created by xmly on 2025/1/23.
//

import simd
import CoreGraphics

// MARK: - Type Aliases
typealias float2 = SIMD2<Float>
typealias float3 = SIMD3<Float>
typealias float4 = SIMD4<Float>

// MARK: - Constants
let π = Float.pi

// MARK: - Float Extensions
extension Float {
    /// 弧度转角度
    var radiansToDegrees: Float {
        (self / π) * 180
    }
    
    /// 角度转弧度
    var degreesToRadians: Float {
        (self / 180) * π
    }
}

// MARK: - float4x4 Extensions
extension float4x4 {
    // MARK: - Static Properties
    /// 单位矩阵
    static var identity: float4x4 {
        matrix_identity_float4x4
    }
    
    // MARK: - Properties
    /// 获取左上角 3x3 矩阵
    var upperLeft: float3x3 {
        let x = columns.0.xyz
        let y = columns.1.xyz
        let z = columns.2.xyz
        return float3x3(columns: (x, y, z))
    }
    
    // MARK: - Translation
    /// 平移矩阵
    init(translation: float3) {
        self = float4x4([            1,             0,             0, 0],
                       [            0,             1,             0, 0],
                       [            0,             0,             1, 0],
                       [translation.x, translation.y, translation.z, 1])
    }
    
    // MARK: - Scale
    /// 缩放矩阵 (3D)
    init(scaling: float3) {
        self = float4x4([scaling.x,         0,         0, 0],
                       [        0, scaling.y,         0, 0],
                       [        0,         0, scaling.z, 0],
                       [        0,         0,         0, 1])
    }
    
    /// 统一缩放矩阵
    init(scaling: Float) {
        self = matrix_identity_float4x4
        columns.3.w = 1 / scaling
    }
    
    // MARK: - Rotation
    /// 绕 X 轴旋转矩阵
    init(rotationX angle: Float) {
        self = float4x4([1,           0,          0, 0],
                       [0,  cos(angle), sin(angle), 0],
                       [0, -sin(angle), cos(angle), 0],
                       [0,           0,          0, 1])
    }
    
    /// 绕 Y 轴旋转矩阵
    init(rotationY angle: Float) {
        self = float4x4([cos(angle), 0, -sin(angle), 0],
                       [         0, 1,           0, 0],
                       [sin(angle), 0,  cos(angle), 0],
                       [         0, 0,           0, 1])
    }
    
    /// 绕 Z 轴旋转矩阵
    init(rotationZ angle: Float) {
        self = float4x4([ cos(angle), sin(angle), 0, 0],
                       [-sin(angle), cos(angle), 0, 0],
                       [          0,          0, 1, 0],
                       [          0,          0, 0, 1])
    }
    
    /// XYZ 顺序旋转矩阵
    init(rotation angle: float3) {
        let rotationX = float4x4(rotationX: angle.x)
        let rotationY = float4x4(rotationY: angle.y)
        let rotationZ = float4x4(rotationZ: angle.z)
        self = rotationX * rotationY * rotationZ
    }
    
    /// YXZ 顺序旋转矩阵
    init(rotationYXZ angle: float3) {
        let rotationX = float4x4(rotationX: angle.x)
        let rotationY = float4x4(rotationY: angle.y)
        let rotationZ = float4x4(rotationZ: angle.z)
        self = rotationY * rotationX * rotationZ
    }
    
    // MARK: - Projection
    /// 透视投影矩阵（左手坐标系）
    init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = lhs ? far / (far - near) : far / (near - far)
        let X = float4( x,  0,  0,  0)
        let Y = float4( 0,  y,  0,  0)
        let Z = lhs ? float4( 0,  0,  z, 1) : float4( 0,  0,  z, -1)
        let W = lhs ? float4( 0,  0,  z * -near,  0) : float4( 0,  0,  z * near,  0)
        self.init()
        columns = (X, Y, Z, W)
    }
    
    /// 正交投影矩阵
    init(orthographic rect: CGRect, near: Float, far: Float) {
        let left = Float(rect.origin.x)
        let right = Float(rect.origin.x + rect.width)
        let top = Float(rect.origin.y)
        let bottom = Float(rect.origin.y - rect.height)
        let X = float4(2 / (right - left), 0, 0, 0)
        let Y = float4(0, 2 / (top - bottom), 0, 0)
        let Z = float4(0, 0, 1 / (far - near), 0)
        let W = float4((left + right) / (left - right),
                      (top + bottom) / (bottom - top),
                      near / (near - far),
                      1)
        self.init()
        columns = (X, Y, Z, W)
    }
    
    /// 视图矩阵（左手坐标系 LookAt）
    init(eye: float3, center: float3, up: float3) {
        let z = normalize(center - eye)
        let x = normalize(cross(up, z))
        let y = cross(z, x)
        
        let X = float4(x.x, y.x, z.x, 0)
        let Y = float4(x.y, y.y, z.y, 0)
        let Z = float4(x.z, y.z, z.z, 0)
        let W = float4(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1)
        
        self.init()
        columns = (X, Y, Z, W)
    }
    
    /// 从 double4x4 转换
    init(_ m: matrix_double4x4) {
        self.init()
        self = float4x4(float4(m.columns.0),
                       float4(m.columns.1),
                       float4(m.columns.2),
                       float4(m.columns.3))
    }
}

// MARK: - float3x3 Extensions
extension float3x3 {
    /// 从 4x4 矩阵创建法线矩阵
    init(normalFrom4x4 matrix: float4x4) {
        self.init()
        columns = matrix.upperLeft.inverse.transpose.columns
    }
}

// MARK: - float4 Extensions
extension float4 {
    /// xyz 分量访问器
    var xyz: float3 {
        get {
            float3(x, y, z)
        }
        set {
            x = newValue.x
            y = newValue.y
            z = newValue.z
        }
    }
    
    /// 从 double4 转换
    init(_ d: SIMD4<Double>) {
        self.init()
        self = [Float(d.x), Float(d.y), Float(d.z), Float(d.w)]
    }
}

