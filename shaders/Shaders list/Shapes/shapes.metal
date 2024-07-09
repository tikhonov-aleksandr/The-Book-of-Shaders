//
//  shapes.metal
//  Shaders
//
//  Created by tikhonov on 29.05.2024.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 square(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;
    half3 resultColor = half3(0);
    float borderWidth = 0.1;
    float2 borders1 = step(float2(borderWidth), st);
    float pct = borders1.x * borders1.y;

    float2 borders2 = step(float2(borderWidth), 1 - st);
    pct *= borders2.x * borders2.y;

    resultColor = half3(pct);

    return half4(resultColor,1);
}

half4 computeCircleColor(float2 position, float2 resolution) {
    float2 st = position / resolution;
    half3 resultColor = half3(1);

    float2 center = float2(0.5, 0.5);
    float2 toCenter = center - st;

    float pct = length(toCenter);
    pct = smoothstep(0.4, 0.45, pct);

    resultColor = half3(pct);

    return half4(resultColor, 1);
}

[[stitchable]] half4 circle4(float2 position, half4 color, float2 resolution) {
    half4 resultColor = computeCircleColor(position, resolution);
    half3 result = mix(half3(1), half3(0.3,0.53,0.2), resultColor.rgb);
    return half4(result, resultColor.a);
}

[[stitchable]] half4 circleAnimation(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;
    half3 resultColor = half3(0);

    float2 center = float2(0.5, 0.5);
    float2 toCenter = center - st;

    float pct = length(toCenter);
    float sintime = sin(time);  // [-1 -> 1]
    sintime = (sintime + 1) / 8.0; // [0 -> 0.25]
    float radius1 = 0.2 + sintime;
    float radius2 = radius1 + 0.05;
    pct = smoothstep(radius1, radius2, pct);

    resultColor = half3(pct);

    return half4(resultColor, 1);
}

[[stitchable]] half4 circle3(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;
    float2 dist = st - float2(0.5, 0.5);

    float radius = 0.3;
    float edge0 = radius * radius - radius * 0.01;
    float edge1 = radius * radius + radius * 0.01;
    float xx = dot(dist, dist) ;
    half3 resultColor = 1.0 - smoothstep(edge0, edge1, xx);

    return half4(resultColor, 1);
}

[[stitchable]] half4 distance_field(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;
    // st = st * 2.0 - 1.0; // st -> [-1, 1];

    float d = length(abs(st)  - float2(0.5));
    // d = length(min(abs(st)-0.5,0.0));
    // d = length(max(abs(st)-0.5,0.0));

    half3 resultColor = half3(fract(d * 10));
    // half3 resultColor = step(0.3, d);
    return half4(resultColor, 1);
}

[[stitchable]] half4 leaf3(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;
    float2 pos = float2(0.5) - st;

    float r = length(pos) * 2.0;
    float a = atan2(pos.y, pos.x);

    float f = abs(cos(a*12.)*sin(a*3.))*.8+.1;

    half3 resultColor = half3(1 - smoothstep(f, f + 0.02, r));
    return half4(resultColor, 1);
}

[[stitchable]] half4 any_shape(float2 position, half4 color, float2 resolution) {

    float2 st = position / resolution;
    st.x *= resolution.x / resolution.y;

    st = st * 2.0 - 1.0;

    float N = 5;

    float a = atan2(st.x, st.y);
    float r = 2.0 * M_PI_F / N;
    
    float d = cos(floor(.5 + a / r) * r - a) * length(st);

    half3 resultColor = half3(1.0 - smoothstep(.3,.31,d));
    return half4(resultColor, 1);
}
