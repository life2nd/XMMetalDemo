//
//  File.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/1/20.
//

#include <metal_stdlib>
using namespace metal;

// 简化的顶点着色器，直接使用顶点数据
struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertexMainChapter5(constant packed_float3 *vertices [[buffer(0)]],
//                                 constant ushort *indices [[buffer(1)]],
                                 constant float4 &color [[buffer(2)]],
                                    constant float4x4 &matrix [[buffer(3)]],
                                uint vid [[vertex_id]]) {
//    ushort index = indices[vid];
//    float4 position = float4(vertices[index], 1);
    float4 position = float4(vertices[vid], 1);
    position = matrix * position;
    VertexOut vertexOut = {
        .position = position,
        .color = color
    };
    return vertexOut;
}

fragment float4 fragmentMainChapter5(const VertexOut vertexOut [[stage_in]]) {
    return vertexOut.color;
}
