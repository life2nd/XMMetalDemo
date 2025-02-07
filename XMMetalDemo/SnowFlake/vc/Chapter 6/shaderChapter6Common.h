//
//  shaderChapter6Common.h
//  XMMetalDemo
//
//  Created by xmly on 2025/1/27.
//

#ifndef shaderChapter6Common_h
#define shaderChapter6Common_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

#endif /* shaderChapter6Common_h */
