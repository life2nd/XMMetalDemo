//
//  shaderChapter8.metal
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

#include <metal_stdlib>
using namespace metal;

#import "CommonChapter8.h"

struct VertexInChapter8 {
    float4 position [[attribute(Position)]];
    float3 normal [[attribute(Normal)]];
    float2 uv [[attribute(UV)]];
};

struct VertexOutChapter8 {
    float4 postion [[position]];
    float3 normal;
    float2 uv;
};

vertex VertexOutChapter8 vertex_mainChapter8 (const VertexInChapter8 in [[stage_in]],
                              constant UniformsChapter8 &uniform [[buffer(UniformsBuffer)]]) {
    
    float4 postion = uniform.projectionMatrix * uniform.viewMatrix * uniform.modelMatrix * in.position;
    VertexOutChapter8 out {
        .postion = postion,
        .normal = in.normal,
        .uv = in.uv
    };
    return out;
}

fragment float4 fragemnt_mainChapter8(VertexOutChapter8 in [[stage_in]], constant ParamsChapter8 &param [[buffer(ParamsBuffer)]]) {
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = in.normal.y * 0.5 + 0.5;
    return mix(earth, sky, intensity);
}
