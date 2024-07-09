//
//  gradient_color_animation.metal
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

#include <metal_stdlib>
using namespace metal;

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}

[[stitchable]] half4 gradient_color_animation(float2 position, half4 color, float2 resolution, float time) {

     float redValue = position.x / resolution.x + time;
     float red = oscillate(redValue);

    float greenValue = position.y / resolution.y + time;
    float green = oscillate(greenValue);

    float blueValue = position.x / resolution.y + time;
    float blue = oscillate(blueValue);

    return  half4(red,green,blue,1);
}

[[stitchable]] half4 simple_gradient(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;
    half3 resultColor = half3(1 - st.x,0,st.x);
    return half4(resultColor,1);
}

[[stitchable]] half4 smoothstepGradient(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;

    float edge0 = 0;
    float edge1 = 1;

    float smoothX = smoothstep(edge0, edge1, st.x);

    half3 resultColor = half3(1 - smoothX,0,smoothX);
    return half4(resultColor,1);
}

// [..., x - 0.02, 0.02 + x, ...
float plot(float2 st, float pct) {
    return smoothstep(pct - 0.02, pct, st.y) - smoothstep(pct, pct + 0.02, st.y);
}

float plot2(float2 st, float pct) {
    return smoothstep(pct - 0.02, pct, 1 - st.y) - smoothstep(pct, pct + 0.02, 1 - st.y); // inverted y-axis
}

[[stitchable]] half4 simple_gradient_green_line(float2 position, half4 color, float2 resolution) {

    float2 st = position / resolution;

    float y = st.x;
    half3 resultColor = half3(y);
    half3 greenColor = half3(0.0, 1.0, 0.0);
    float pct = smoothstep(0.02, 0.0, abs(st.y - st.x) );

    resultColor = pct * greenColor + (1.0 - pct) * resultColor;

    return half4(resultColor,1);

//    float2 st = position / resolution;
//    half3 resultColor = half3(st.x,st.x,st.x);
//
//    float y = smoothstep(0.1, 0.9, st.x);
//    float pl = plot(st, y);
//    resultColor = (1.0 - pl) * resultColor + pl * half3(0.0, 1.0, 0.0);
//
//    return half4(resultColor,1);
}

[[stitchable]] half4 simple_gradient_green_line2(float2 position, half4 color, float2 resolution) {

    float2 st = position / resolution;
    float y = pow(st.x, 5);
    half3 resultColor = half3(y);

    float pl = plot2(st, y);
    resultColor = (1.0 - pl) * resultColor + pl * half3(0.0, 1.0, 0.0);

    return half4(resultColor,1);
}

[[stitchable]] half4 mix_colors(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    half3 resultColor = half3(0.0, 0.0, 0.0);

    half3 pct = half3(st.x);

    half3 colorA = half3(0.149,0.141,0.912);
    half3 colorB = half3(1.000,0.833,0.224);

    pct.r = smoothstep(0.0, 1.0, st.x);
    pct.g = sin(st.x);
    pct.b = pow(st.x, 0.5);

    resultColor = mix(colorA, colorB, pct);

    resultColor = mix(resultColor, half3(1.0, 0.0, 0.0), plot(st, pct.r));
    resultColor = mix(resultColor, half3(0.0, 1.0, 0.0), plot(st, pct.g));
    resultColor = mix(resultColor, half3(0.0, 0.0, 1.0), plot(st, pct.b));

    return half4(resultColor, 1);
}

// Function to convert HSB to RGB
float3 HSBtoRGB(float hue, float saturation, float brightness) {
    float r, g, b;

    int i = int(hue * 6.0);
    float f = hue * 6.0 - float(i);
    float p = brightness * (1.0 - saturation);
    float q = brightness * (1.0 - f * saturation);
    float t = brightness * (1.0 - (1.0 - f) * saturation);

    switch (i % 6) {
        case 0: r = brightness; g = t; b = p; break;
        case 1: r = q; g = brightness; b = p; break;
        case 2: r = p; g = brightness; b = t; break;
        case 3: r = p; g = q; b = brightness; break;
        case 4: r = t; g = p; b = brightness; break;
        case 5: r = brightness; g = p; b = q; break;
    }

    return float3(r, g, b);
}

[[stitchable]] half4 hsb_first(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;

    float hue = st.x;
    float saturation = 1.0;
    float brightness = st.y;

    half3 resultColor = half3(HSBtoRGB(hue, saturation, brightness));

    return half4(resultColor, 1);
}

[[stitchable]] half4 hsb_second(float2 position, half4 color, float2 resolution, float time) {
    float2 st = position / resolution;

    float2 toCenter = float2(0.5) - st;
    float angle = atan2(toCenter.y, toCenter.x);
    float radius = length(toCenter) * 2;

    float hue = angle / (M_PI_H * 2) + 0.5; //[-pi; pi] -> [0, 1]
    hue += time * 0.05;
    hue = fract(hue);
    float saturation = radius;
    float brightness = 1.0;

    half3 resultColor = half3(HSBtoRGB(hue, saturation, brightness));

    // clip to circle
    float xx = (st.x - 0.5) * (st.x - 0.5) + (st.y - 0.5) * (st.y - 0.5);
    float rr = 0.5 * 0.5;

    float pct = step(xx, rr);
    
    half3 whiteColor = half3(1,1,1);
    resultColor = (1 - pct) * whiteColor + pct * resultColor;

    return half4(resultColor, 1);
}

float plot3(float2 st, float pct, float width) {
    return smoothstep(pct - width, pct, 1 - st.y) - smoothstep(pct, pct + width, 1 - st.y); // inverted y-axis
}

[[stitchable]] half4 rainbow(float2 position, half4 color, float2 resolution) {
    float2 st = position / resolution;

    half3 resultColor = half3(1,1,1);

    const int arraySize = 6;
    half3 colors[arraySize] = {
        half3(1.0, 0.0, 0.0),  // Red
        half3(1.0, 0.5, 0.0),  // Orange
        half3(1.0, 1.0, 0.0),  // Yellow
        half3(0.0, 1.0, 0.0),  // Green
        half3(0.0, 0.0, 1.0),  // Blue
        half3(0.5, 0.0, 0.5)   // Violet
    };
    float width = 0.05;
    float shift = 0.0;
    float space = 0.02;
    for (int i = 0; i < arraySize; i++) {
        half3 selectedColor = colors[i];
        //float y = sin((st.x * M_PI_F - shift) ) *0.9 - shift;
        float y = (st.x - shift - space);
        float pl = plot3(st, y, width);
        pl = ceil(pl);
        resultColor = mix(resultColor, selectedColor, pl);
        shift += width;
        space += width;
    }

    return half4(resultColor,1);
}


