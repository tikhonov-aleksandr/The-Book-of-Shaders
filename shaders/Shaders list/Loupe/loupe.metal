//
//  loupe.metal
//  Shaders
//
//  Created by tikhonov on 14.05.2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


[[ stitchable ]] half4 loupe(float2 pos, SwiftUI::Layer layer, float2 size, float2 touch) {

    float maxDistance = 0.05;

    float2 uv = pos / size;
    float2 center = touch / size;
    float2 delta = uv - center;
    float aspectRation = size.x / size.y;

    float distance = (delta.x * delta.x) + (delta.y * delta.y) / aspectRation;

    float totalZoom = 1;

    if (distance < maxDistance) {
        totalZoom /= 2;
        totalZoom += distance * 10;
    }

    float2 newPos = delta * totalZoom + center;

    return layer.sample(newPos * size);
}

[[ stitchable ]] half4 red_dot(float2 pos, SwiftUI::Layer layer, float2 size, float2 touch) {

    half4 redColor = half4(1.0, 0.0, 0.0, 1.0);
    float radius = 20.0;
    float innerRadius = 10.0;

    float distance = length(pos - touch);

    if (distance <= radius) {
        if (distance <= innerRadius) {
            return layer.sample(pos);
        } else {
            return redColor;
        }
    }

    return layer.sample(pos);
}
