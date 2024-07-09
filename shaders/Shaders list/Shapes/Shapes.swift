//
//  Shapes.swift
//  Shaders
//
//  Created by tikhonov on 29.05.2024.
//

import SwiftUI

struct ShapesView: View {

    var body: some View {
        List {
            Section("Shaping functions") {
                VStack(alignment: .leading) {
                    ForEach(PlotFunction.allCases) { plotFunction in
                        VStack(spacing: 0.0) {
                            Text(plotFunction.name)
                            Rectangle()
                                .frame(height: 100)
                                .greenLine(plotFunction: plotFunction)
                        }
                    }
                }
            }
            VStack(alignment: .center) {
                Rectangle()
                    .frame(width: 100, height: 100)
                    .square()
                Rectangle()
                    .frame(width: 100, height: 100)
                    .circle3()
                Rectangle()
                    .frame(width: 100, height: 100)
                    .circle4()
                Rectangle()
                    .frame(width: 200, height: 200)
                    .distanceField()
                Rectangle()
                    .frame(width: 100, height: 100)
                    .circleAnimation()
                Rectangle()
                    .frame(width: 100, height: 100)
                    .leaf3()
                Rectangle()
                    .frame(width: 100, height: 100)
                    .anyShape()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)

    }
}

extension View {
    func square() -> some View {
        modifier(Square())
    }
}

struct Square: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.square(.float2(proxy.size)))
            }
    }
}

extension View {
    func circle3() -> some View {
        modifier(Circle3Modifier())
    }
}

struct Circle3Modifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.circle3(
                        .float2(proxy.size)
                    ))
            }

    }
}

extension View {
    func circle4() -> some View {
        modifier(Circle4Modifier())
    }
}

struct Circle4Modifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.circle4(
                        .float2(proxy.size)
                    ))
            }

    }
}

extension View {
    func distanceField() -> some View {
        modifier(DistanceFieldModifier())
    }
}

struct DistanceFieldModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.distance_field(
                        .float2(proxy.size)
                    ))
            }

    }
}


extension View {
    func circleAnimation() -> some View {
        modifier(CircleAnimationModifier())
    }
}

struct CircleAnimationModifier: ViewModifier {

    var startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.circleAnimation(
                            .float2(proxy.size),
                            .float(startDate.timeIntervalSinceNow)))
                }
        }
    }
}

extension View {
    func leaf3() -> some View {
        modifier(Leaf3Modifier())
    }
}

struct Leaf3Modifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.leaf3(
                        .float2(proxy.size)))
            }
    }
}

extension View {
    func anyShape() -> some View {
        modifier(AnyShapeModifier())
    }
}

struct AnyShapeModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.any_shape(
                        .float2(proxy.size)))
            }
    }
}

#Preview {
    ShapesView()
}

