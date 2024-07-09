//
//  patterns.metal
//  Shaders
//
//  Created by tikhonov on 30.06.2024.
//

#include <metal_stdlib>
using namespace metal;

float circle(float2 st, float radius) {
    float2 dis = st - 0.5;
    float xx = dot(dis, dis) * 5;
    return smoothstep(radius, radius + 0.01, xx);
}

float circle1(float2 st, float radius, int2 pos) {
    float2 dis = st - 0.5;
    float xx = dot(dis, dis) * 5;

    float s = pos.y == 1 ? 1.0 : 0.5;

    return s - smoothstep(radius, radius + 0.01, xx);
}

[[stitchable]] half4 simple_grid(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    st *= 3;
    int2 pos = int2(st);
    st = fract(st);

    // Now we have 9 spaces that go from 0-1

    half3 resultColor = half3(st.x, st.y, 0.0);
    resultColor = circle1(st, 0.5, pos);

    return half4(resultColor,1);
}

float2 tile(float2 st, float zoom) {
    st *= zoom;
    return fract(st);
}

float box1(float2 st, float2 size) {

    size = float2(0.5) - size * 0.5;

    float2 uv = smoothstep(size, size + float2(0.001), st);
    uv *= smoothstep(size, size + float2(0.001), 1 - st);
    return uv.x * uv.y;
}

float2x2 rotated2d1(float angle) {
    return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float2 rotate1(float2 st, float angle) {
    st -= 0.5;
    st = rotated2d1(angle) * st;
    st += 0.5;
    return st;
}

[[stitchable]] half4 rhombus(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    // Divide he space in 4;
    st = tile(st, 4);

    // Use matrix to rotate the space by 45.0
    st = rotate1(st, M_PI_4_F);

    st = box1(st, 0.7);

    half3 resultColor = half3(st.x);

    return half4(resultColor,1);
}

float2 brickTile(float2 st, float zoom, float time) {
    st *= zoom;

    float offsetX = step(1.0, fmod(st.y, 2.0));
    float offsetY = step(1.0, fmod(st.x, 2.0));
    // [0; 1];

    float stime = sin(time * M_PI_F); // [-1; 1]

    st.x += (offsetX * 2.0 - 1.0)*time * step(0.0, stime);
    st.y += (offsetY * 2.0 - 1.0)*time * (1.0 - step(0.0, stime));


    return fract(st);
}

[[stitchable]] half4 bricks(float2 position, half4 color, float2 resolution, float time) {

    float2 st = position / resolution;

    st = brickTile(st, 15.0, time);

    st = circle(st, 0.4);

    half3 resultColor = half3(st.x);

    return half4(resultColor,1);
}
