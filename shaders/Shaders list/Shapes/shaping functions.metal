//
//  shaping functions.metal
//  Shaders
//
//  Created by tikhonov on 07.07.2024.
//

#include <metal_stdlib>
using namespace metal;

typedef float (*FunctionType)(float);

enum PlotFunction {
    Linear = 0, // y = x
    Quadratic = 1, // y = x * x
    Sine = 2, // y = sin(x)
    Cosine = 3, // y = cos(x)
    Exponential = 4, // y = e^x
    Logarithmic = 5, // y = ln(x)
    Absolute = 6, // y = abs(x)
    Reciprocal = 7 // y = 1/x
};


float linear(float x) {
    return x;
}

float quadratic(float x) {
    return x * x;
}

float sine(float x) {
    x *= 10;
    return sin(x);
}

float cosine(float x) {
    x *= 10;
    return cos(x);
}

float exponential(float x) {
    return exp(x) / 3;
}

float logarithmic(float x) {
    x *= 2;
    return log(x);
}

float absolute(float x) {
    return abs(x);
}

float reciprocal(float x) {
    x *= 3;
    return 1.0 / x;
}

FunctionType getPlotFunction(PlotFunction plotFunction) {
    switch (plotFunction) {
        case Linear:
            return &linear;
        case Quadratic:
            return &quadratic;
        case Sine:
            return &sine;
        case Cosine:
            return &cosine;
        case Exponential:
            return &exponential;
        case Logarithmic:
            return &logarithmic;
        case Absolute:
            return &absolute;
        case Reciprocal:
            return &reciprocal;
    }
}

/// Returns 0 if the point doens't belong to the provided chart otherwise 1.
float plot(float sty, float y, float width) {
    float leftOffset = sty - width;
    float rightOffset = sty + width;
    float left = smoothstep(leftOffset, sty, y);
    float right = smoothstep(sty, rightOffset, y);
    float comb = left - right;
    return comb;
}

float plotYAxisInverted(float sty, float y, float width) {
    return plot(sty, 1.0 - y, width);
}

[[stitchable]] half4 green_line(float2 position, half4 color, float2 resolution, float plotFunctionValue) {

    float2 st = position / resolution;

//    st *= 2;
//    st -= 1;

    int plotFunctionInt = int(plotFunctionValue);
    PlotFunction plotFunction = PlotFunction(plotFunctionInt);

    FunctionType func = getPlotFunction(plotFunction);

    float y = func(st.x);

    float plot = plotYAxisInverted(st.y, y, 0.01); // 0 or 1

    half3 resultColor = (1 - plot) * half3(y) + plot * half3(0.0, 1.0, 0.0); // original or green color

    return half4(resultColor, 1.0);
}
