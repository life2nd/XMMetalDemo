//
//  shaderDemoOne.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/2/13.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertexMainDemoOne(constant packed_float3 *vertices [[buffer(0)]],
                                 uint vertexIndex [[vertex_id]]) {
    float4 position = float4(vertices[vertexIndex], 1);
    return position;
}

// 构建下雪的场景
constant int _SnowflakeAmount = 50;    // Number of snowflakes
constant float _BlizardFactor = 0.2f;   // Fury of the storm !

// 随机数生成函数
float rnd(float x, float2 constants)
{
    return fract(sin(dot(float2(x + 47.49, 38.2467/(x + 2.3)), constants)) * 43758.5453);
}

// 绘制圆形函数
float drawCircle(float2 uv, float2 center, float radius)
{
    return 1.0 - smoothstep(0.0, radius, length(uv - center));
}

// 主要的片段着色器函数
fragment float4 fragmentMainDemoOne(float4 pos [[position]],
                                    constant float &time [[buffer(0)]],
                                    constant float2 &resolution [[buffer(1)]])
{
    
    float2 uv = pos.xy / resolution.x;
    
    // 基础背景色（淡蓝色）
    float4 fragColor = float4(0.808, 0.89, 0.918, 1.0);
    
    // 常量用于随机数生成
    float2 constants = float2(12.9898, 78.233);
    
    // 生成雪花
    for(int i = 0; i < _SnowflakeAmount; i++)
    {
        float j = float(i);
        float speed = 0.3 + rnd(cos(j), constants) * (0.7 + 0.5 * cos(j/(float(_SnowflakeAmount) * 0.25)));
        
        float2 center = float2(
            (0.25 - uv.y) * _BlizardFactor + rnd(j, constants) + 0.1 * cos(time + sin(j)),
            fmod(sin(j) - speed * (time * 1.5 * (0.1 + _BlizardFactor)), 0.65)
        );
        
        fragColor += float4(float3(0.09 * drawCircle(uv, center, 0.001 + speed * 0.012)), 0.0);
    }
    
    return fragColor;
}
