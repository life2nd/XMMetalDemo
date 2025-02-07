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
};

struct VertexOutChapter7 {
    float4 position [[position]];
};

vertex VertexOutChapter7 vertex_mainChapter7(VertexInChapter7 vertexIn [[stage_in]],
                                             constant UniformsChapter7 &uniforms [[buffer(11)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexIn.position;
    VertexOutChapter7 out {
        .position = position
    };
    return out;
}

fragment float4 fragment_mainChapter7() {
    return float4(0.2, 0.5, 1.0, 1);
}

