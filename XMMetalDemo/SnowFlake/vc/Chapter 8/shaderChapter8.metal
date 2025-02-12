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
    float4 position [[attribute(PositionChapter8)]];
    float3 normal [[attribute(NormalChapter8)]];
    float2 uv [[attribute(UVChapter8)]];
};

struct VertexOutChapter8 {
    float4 postion [[position]];
    float3 normal;
    float2 uv;
};

vertex VertexOutChapter8 vertex_mainChapter8 (const VertexInChapter8 in [[stage_in]],
                              constant UniformsChapter8 &uniform [[buffer(UniformsBufferChapter8)]]) {
    
    float4 postion = uniform.projectionMatrix * uniform.viewMatrix * uniform.modelMatrix * in.position;
    VertexOutChapter8 out {
        .postion = postion,
        .normal = in.normal,
        .uv = in.uv
    };
    return out;
}

fragment float4 fragemnt_mainChapter8(VertexOutChapter8 in [[stage_in]], constant ParamsChapter8 &param [[buffer(ParamsBufferChapter8)]], texture2d<float> baseColorTexture [[texture(BaseColorChapter8)]]) {
    
    constexpr sampler textureSampler(filter::linear, address::repeat, mip_filter::linear, max_anisotropy(8));
    float3 baseColor = baseColorTexture.sample(textureSampler, in.uv * param.tiling).rgb;
    return float4(baseColor, 1);
}
