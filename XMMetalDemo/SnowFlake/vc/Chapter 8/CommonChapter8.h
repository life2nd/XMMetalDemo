//
//  CommonChapter8.h
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/8.
//

#ifndef CommonChapter8_h
#define CommonChapter8_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} UniformsChapter8;

typedef struct {
    uint width;
    uint height;
} ParamsChapter8;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    UniformsBuffer = 11,
    ParamsBuffer = 12
} BufferIndices;

typedef enum {
    Position = 0,
    Normal = 1,
    UV = 2
} Attributes;

#endif /* CommonChapter8_h */
