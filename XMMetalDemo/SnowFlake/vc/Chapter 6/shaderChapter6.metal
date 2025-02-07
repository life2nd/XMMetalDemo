//
//  shaderChapter6.metal
//
//  Created by xmly on 2025/1/23.
//

#include <metal_stdlib>
using namespace metal;

#import "shaderChapter6Common.h"

struct VertexInChapter6 {
    float4 position [[attribute(0)]];
};

struct VertexOutChapter6 {
    float4 position [[position]];
};

vertex VertexOutChapter6 vertex_mainChapter6(VertexInChapter6 vertexIn [[stage_in]],
                                             constant Uniforms &uniforms [[buffer(11)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexIn.position;
    VertexOutChapter6 out {
        .position = position
    };
    return out;
}

fragment float4 fragment_mainChapter6() {
    return float4(0.2, 0.5, 1.0, 1);
}
