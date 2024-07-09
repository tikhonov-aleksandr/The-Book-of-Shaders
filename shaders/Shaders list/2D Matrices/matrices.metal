//
//  matrices.metal
//  Shaders
//
//  Created by tikhonov on 29.06.2024.
//

#include <metal_stdlib>
using namespace metal;

float box(float2 st, float2 size) {

    size = float2(0.5) - size * 0.5;

    float2 uv = smoothstep(size, size + float2(0.001), st);
    uv *= smoothstep(size, size + float2(0.001), 1 - st);
    return uv.x * uv.y;
}

float cross(float2 st, float size) {
    float boxV = box(st, float2(size, size/4.0));

    float boxH = box(st, float2(size / 4.0, size));

    return  boxH + boxV;
}

float2x2 rotated2d(float angle) {
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float2x2 scale2d(float2 scale) {
    return float2x2(scale.x, 0, 0, scale.y);
}

[[stitchable]] half4 plus(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    float2 translate = float2(cos(time), sin(time));
    st += translate * 0.35;

    half3 resultColor = half3(st.x, st.y, 0.0);

    resultColor += half3(cross(st, 0.25));

    return half4(resultColor,1);
}

[[stitchable]] half4 plus_rotation(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    st -= 0.5;
    st = rotated2d(sin(time) * M_PI_F) * st;
    st += 0.5;

    half3 resultColor = half3(st.x, st.y, 0.0);

    resultColor += half3(cross(st, 0.25));

    return half4(resultColor,1);
}

[[stitchable]] half4 plus_scale(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    st -= 0.5;
    st = scale2d(sin(time) ) * st;
    st += 0.5;

    half3 resultColor = half3(st.x, st.y, 0.0);

    resultColor += half3(cross(st, 0.25));

    return half4(resultColor,1);
}

// YUV to RGB matrix
constant float3x3 yuv2rgb = float3x3(float3(1.0, 0.0, 1.13983),
                            float3(1.0, -0.39465, -0.58060),
                            float3(1.0, 2.03211, 0.0));

// RGB to YUV matrix
constant float3x3 rgb2yuv = float3x3(float3(0.2126, 0.7152, 0.0722),
                            float3(-0.09991, -0.33609, 0.43600),
                            float3(0.615, -0.5586, -0.05639));


[[stitchable]] half4 YUV(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    // UV values goes from -1 to 1
    // So we need to remap st (0.0 to 1.0)
    st -= 0.5;  // becomes -0.5 to 0.5
    st *= 2.0;  // becomes -1.0 to 1.0

    // we pass st as the y & z values of
       // a three dimensional vector to be
       // properly multiply by a 3x3 matrix
    float3 resultColor = yuv2rgb * float3(0.5, st.y, st.x);

    return half4(half3(resultColor),1);
}
