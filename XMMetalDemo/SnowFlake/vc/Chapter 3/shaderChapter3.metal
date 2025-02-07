//
//  shaderChapter3.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/1/16.
//

#include <metal_stdlib>
using namespace metal;


struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertexMainChapter3(const VertexIn vertexIn [[stage_in]]) {
    float4 position = vertexIn.position;
    position.y -= 0;
    return position;
}

fragment float4 fragmentMainChapter3() {
    return float4(1, 0, 0, 1);
}
