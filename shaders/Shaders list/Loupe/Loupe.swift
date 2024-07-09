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
                .navigationTitle("Loupe")
            Image("mountain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .redDot()
                .navigationTitle("Loupe")
        }
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

extension View {
    func loupe() -> some View {
        modifier(Loupe())
    }

    func redDot() -> some View {
        modifier(RedDot())
    }
}

#Preview {
    NavigationStack {
        LoupeView()
    }
}
