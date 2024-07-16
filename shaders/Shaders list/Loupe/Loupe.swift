//
//  Loupe.swift
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

import SwiftUI

struct LoupeView: View {
    var body: some View {
        VStack {
            Image("mountain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .loupe()
            Image("mountain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .redDot()
            Text("Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World!")
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .background(Color.black)
                .text3D()
        }
        .navigationTitle("Loupe")
    }
}

struct Loupe: ViewModifier {

    @State var touch = CGPoint.zero

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content.layerEffect(
                    ShaderLibrary.loupe(
                        .float2(proxy.size),
                        .float2(touch)
                    ), maxSampleOffset: .zero)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {  touch = $0.location }
            )
    }
}

struct RedDot: ViewModifier {

    @State var touch = CGPoint.zero

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content.layerEffect(
                    ShaderLibrary.red_dot(
                        .float2(proxy.size),
                        .float2(touch)
                    ), maxSampleOffset: .zero)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {  touch = $0.location }
            )
    }
}

struct Text3D: ViewModifier {

    @State private var dragLocation = CGPoint(x: 0, y: 0)
    @State private var dragVelocity = CGPoint(x: 0, y: 0)

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content.layerEffect(
                    ShaderLibrary.text3d(
                        .float2(dragLocation),
                        .float2(dragVelocity)
                    ), maxSampleOffset: .zero)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.dragLocation = value.location
                        self.dragVelocity = CGPoint(
                            x: value.predictedEndLocation.x - value.location.x,
                            y: value.predictedEndLocation.y - value.location.y
                        )
                    }
            )
    }
}

extension View {
    func loupe() -> some View {
        modifier(Loupe())
    }

    func redDot() -> some View {
        modifier(RedDot())
    }

    func text3D() -> some View {
        modifier(Text3D())
    }
}

#Preview {
    NavigationStack {
        LoupeView()
    }
}
