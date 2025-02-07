//
//  shaderChapter4.metal
//  XMMetalDemo
//
//  Created by xmly on 2025/1/17.
//

#include <metal_stdlib>
using namespace metal;

// Part1
vertex float4 vertexMainChapter4(constant packed_float3 *vertices [[buffer(0)]],
                                 constant float &timer [[buffer(11)]],
                                 uint vertexIndex [[vertex_id]]) {
    float4 position = float4(vertices[vertexIndex], 1);
    position.y = position.y + timer;
    return position;
}

fragment float4 fragmentMainChapter4() {
    return float4(0, 0, 1, 1);
}

// Part2
vertex float4 vertexMainChapter4Part2(constant packed_float3 *vertices [[buffer(0)]],
                                      constant ushort *indices [[buffer(1)]],
                                      constant float &timer [[buffer(11)]],
                                      uint vertexIndex [[vertex_id]]) {
    ushort index = indices[vertexIndex];
    float4 position = float4(vertices[index], 1);
    position.y += timer;
    return position;
}

fragment float4 fragmentMainChapter4Part2() {
    return float4(1, 0, 0, 1);
}

// Part3
vertex float4 vertexMainChapter4Part3(const float4 position [[attribute(0)]] [[stage_in]],
                                      constant float &timer [[buffer(11)]]) {
    float4 nPosition = float4(position);
    nPosition.y += timer;
    return nPosition;
}

fragment float4 fragmentMainChapter4Part3() {
    return float4(0, 1, 0, 1);
}

// Part4
struct VertexInPart4 {
    float4 position [[attribute(0)]];
    float3 color [[attribute(1)]];
};

struct VertexOutPart4 {
    float4 position [[position]];
    float3 color;
};

vertex VertexOutPart4 vertexMainChapter4Part4(const VertexInPart4 vertexIn [[stage_in]],
                                              constant float &timer [[buffer(11)]]) {
    
    VertexOutPart4 out {
        .position = vertexIn.position,
        .color = vertexIn.color
    };
    out.position.y += timer;
    return out;
}

fragment float4 fragmentMainChapter4Part4(const VertexOutPart4 in [[stage_in]]) {
    return float4(in.color, 1);
}

// Part5
struct VertexInPart5 {
    float4 position [[attribute(0)]];
    float3 color [[attribute(1)]];
    float pointSize [[attribute(2)]];
};

struct VertexOutPart5 {
    float4 position [[position]];
    float3 color;
    float pointSize [[point_size]];
};

vertex VertexOutPart5 vertexMainChapter4Part5(const VertexInPart5 vertexIn [[stage_in]],
                                              constant float &timer [[buffer(11)]]) {
    
    VertexOutPart5 out {
        .position = vertexIn.position,
        .color = vertexIn.color,
        .pointSize = vertexIn.pointSize
    };
    out.position.y += timer;
    return out;
}

fragment float4 fragmentMainChapter4Part5(const VertexOutPart5 in [[stage_in]]) {
    return float4(in.color, 1);
}
