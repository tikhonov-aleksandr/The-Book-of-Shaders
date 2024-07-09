//
//  GradientColorAnimation.swift
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        List {

            
            Rectangle()
                .frame(height: 100)
                .rainbow()

            Rectangle()
                .frame(height: 100)
                .simpleGradient()
            Rectangle()
                .frame(height: 100)
                .smoothstepGradient()
            Rectangle()
                .frame(height: 100)
                .simpleGradientGreenLine()
            Rectangle()
                .frame(height: 100)
                .mixColors()
            Rectangle()
                .frame(height: 100)
                .hsb_first()
            Rectangle()
                .frame(width: 100, height: 100)
                .hsb_second()
            Rectangle()
                .frame(height: 100)
                .gradientColorAnimation()
        }
        .navigationTitle("Gradients")
    }
}

struct GradientColorAnimation: ViewModifier {

    private var startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { context in
            content
                .visualEffect { content, geometryProxy in
                    content
                        .colorEffect(ShaderLibrary.gradient_color_animation(
                            .float2(geometryProxy.size),
                            .float(startDate.timeIntervalSinceNow)
                        ))
                }
        }
    }
}

extension View {
    func gradientColorAnimation() -> some View {
        modifier(GradientColorAnimation())
    }
}

extension View {
    func smoothstepGradient() -> some View {
        modifier(SmoothstepGradient())
    }
}

struct SmoothstepGradient: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.smoothstepGradient(.float2(proxy.size)))
            }
    }
}

extension View {
    func simpleGradient() -> some View {
        modifier(SimpleGradient())
    }
}

struct SimpleGradient: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.simple_gradient(.float2(proxy.size)))
            }
    }
}

extension View {
    func simpleGradientGreenLine() -> some View {
        modifier(SimpleGradientGreenLine())
    }
}

struct SimpleGradientGreenLine: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.simple_gradient_green_line2(.float2(proxy.size)))
            }
    }
}

extension View {
    func mixColors() -> some View {
        modifier(MixColors())
    }
}

struct MixColors: ViewModifier {

    var startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.mix_colors(.float2(proxy.size), .float(startDate.timeIntervalSinceNow)))
                }
        }
    }
}

extension View {
    func hsb_first() -> some View {
        modifier(HSBFirst())
    }
}

struct HSBFirst: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.hsb_first(.float2(proxy.size)))
            }

    }
}

extension View {
    func hsb_second() -> some View {
        modifier(HSBSecond())
    }
}

struct HSBSecond: ViewModifier {

    var startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.hsb_second(.float2(proxy.size), .float(startDate.timeIntervalSinceNow)))
                }
        }
    }
}

extension View {
    func rainbow() -> some View {
        modifier(Rainbow())
    }
}

struct Rainbow: ViewModifier {

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.rainbow(.float2(proxy.size)))

            }
    }
}

#Preview {
    NavigationStack {
        GradientView()
    }
}
