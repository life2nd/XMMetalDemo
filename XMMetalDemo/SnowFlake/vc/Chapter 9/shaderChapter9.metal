//
//  shaderChapter8.metal
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/9.
//

#include <metal_stdlib>
using namespace metal;

#import "CommonChapter9.h"

struct VertexInChapter9 {
    float4 position [[attribute(PositionChapter9)]];
    float3 normal [[attribute(NormalChapter9)]];
    float2 uv [[attribute(UVChapter9)]];
};

struct VertexOutChapter9 {
    float4 postion [[position]];
    float3 normal;
    float2 uv;
};

vertex VertexOutChapter9 vertex_mainChapter9 (const VertexInChapter9 in [[stage_in]],
                              constant UniformsChapter9 &uniform [[buffer(UniformsBufferChapter9)]]) {
    
    float4 postion = uniform.projectionMatrix * uniform.viewMatrix * uniform.modelMatrix * in.position;
    VertexOutChapter9 out {
        .postion = postion,
        .normal = in.normal,
        .uv = in.uv
    };
    return out;
}

fragment float4 fragemnt_mainChapter9(VertexOutChapter9 in [[stage_in]], constant ParamsChapter9 &param [[buffer(ParamsBufferChapter9)]], texture2d<float> baseColorTexture [[texture(BaseColorChapter9)]]) {
    
    constexpr sampler textureSampler(filter::linear, address::repeat, mip_filter::linear, max_anisotropy(8));
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * param.tiling).rgb;
    return float4(baseColor, 1);
}
