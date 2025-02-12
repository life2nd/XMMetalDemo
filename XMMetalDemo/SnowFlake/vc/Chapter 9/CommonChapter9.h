//
//  CommonChapter9.h
//  XMMetalDemo
//
//  Created by 吕品 on 2025/2/8.
//

#ifndef CommonChapter9_h
#define CommonChapter9_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} UniformsChapter9;

typedef struct {
    uint width;
    uint height;
    uint tiling;
} ParamsChapter9;

typedef enum {
    VertexBufferChapter9 = 0,
    UVBufferChapter9 = 1,
    UniformsBufferChapter9 = 11,
    ParamsBufferChapter9 = 12
} BufferIndicesChapter9;

typedef enum {
    PositionChapter9 = 0,
    NormalChapter9 = 1,
    UVChapter9 = 2
} AttributesChapter9;

typedef enum {
    BaseColorChapter9 = 0
} TextureIndicesChapter9;

#endif /* CommonChapter9_h */
