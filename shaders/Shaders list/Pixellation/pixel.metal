//
//  layer.metal
//  Shaders
//
//  Created by tikhonov on 26.05.2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 pixellation(float2 position, SwiftUI::Layer layer, float size, float time) {

    float x = position.x;
    float y = position.y;

    float sample_x = sin(time) + size * round(x / size);
    float sample_y = cos(time) + size * round(y / size);

    return layer.sample(float2(sample_x, sample_y));
}
