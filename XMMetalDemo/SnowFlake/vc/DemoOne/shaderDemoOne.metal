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

// 主要的片段着色器函数
fragment float4 fragmentMainDemoOne(float4 pos [[position]],
                                    constant float &time [[buffer(0)]],
                                    constant float2 &resolution [[buffer(1)]])
{
    return float4(1.0, 0.9, 0.4, 1.0);
}
