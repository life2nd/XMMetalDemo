//
//  shaderChapter7Common.h
//  XMMetalDemo
//
//  Created by xmly on 2025/2/7.
//

#ifndef shaderChapter7Common_h
#define shaderChapter7Common_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} UniformsChapter7;

typedef struct {
    uint screenScale;
    uint width;
    uint height;
} ParamsChatper7;

#endif /* shaderChapter7Common_h */
