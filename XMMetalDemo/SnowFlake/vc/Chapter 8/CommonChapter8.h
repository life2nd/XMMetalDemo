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
    uint tiling;
} ParamsChapter8;

typedef enum {
    VertexBufferChapter8 = 0,
    UVBufferChapter8 = 1,
    UniformsBufferChapter8 = 11,
    ParamsBufferChapter8 = 12
} BufferIndicesChapter8;

typedef enum {
    PositionChapter8 = 0,
    NormalChapter8 = 1,
    UVChapter8 = 2
} AttributesChapter8;

typedef enum {
    BaseColorChapter8 = 0
} TextureIndicesChapter8;

#endif /* CommonChapter8_h */
