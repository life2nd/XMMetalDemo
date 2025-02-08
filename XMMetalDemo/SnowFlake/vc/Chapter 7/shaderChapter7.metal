//
//  File.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

#include <metal_stdlib>
using namespace metal;

#import "shaderChapter7Common.h"

struct VertexInChapter7 {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
};

struct VertexOutChapter7 {
    float4 position [[position]];
    float3 normal;
};

vertex VertexOutChapter7 vertex_mainChapter7(VertexInChapter7 vertexIn [[stage_in]],
                                             constant UniformsChapter7 &uniforms [[buffer(11)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexIn.position;
    VertexOutChapter7 out {
        .position = position,
        .normal = vertexIn.normal
    };
    return out;
}

fragment float4 fragment_mainChapter7(VertexOutChapter7 in [[stage_in]], constant ParamsChatper7 &params [[buffer(12)]]) {
    
    // setp
//    float color;
//    float space = params.width * params.screenScale * 0.5;
//    color = step(space, in.position.x);
//    return float4(color, color, color, 1);
    
    // checkerboard
//    uint checks = 8;
//    float2 uv = in.position.xy / params.width;
//    uv = fract(uv * checks * 0.5) - 0.5;
//    float3 color = step(uv.x * uv.y, 0.0);
//    return float4(color, 1);
    
    // length ? 处理的不对，坐标系没搞明白
//    float center = 0.5;
//    float radius = 0.8;
//    float2 uv = float2(in.position.x / params.width, in.position.y / params.height);
//    float3 color = step(length(uv), radius);
//    return float4(color, 1);
    
    // smoothstep
//    float color = smoothstep(0, params.width, in.position.x);
//    return float4(color, color, color, 1);
    
    // mix、为啥效果不对。。。？
//    float3 red = float3(1, 0, 0);
//    float3 blue = float3(0, 0, 1);
//    float result = smoothstep(0, params.width, in.position.x);
//    float3 color = mix(red, blue, result);
//    return float4(color, 1);
    
    // normalize
//    float3 color = normalize(in.position.xyz);
//    return float4(color, 1);
    
    // normal
//    float3 color = normalize(in.normal);
//    return float4(color, 1);
    
    // Hemispheric Lighting
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = in.normal.y * 0.5 + 0.5;
    return mix(earth, sky, intensity);
}

