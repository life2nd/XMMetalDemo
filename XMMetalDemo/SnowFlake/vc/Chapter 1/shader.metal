//
//  shader.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/1/15.
//

#include <metal_stdlib>
using namespace metal;


struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertexMain(const VertexIn vertexIn [[stage_in]]) {
    return vertexIn.position;
}

fragment float4 fragmentMain() {
    return float4(1, 0, 0, 1);
}
