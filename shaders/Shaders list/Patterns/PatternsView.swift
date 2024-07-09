//
//  PatternsView.swift
//  Shaders
//
//  Created by tikhonov on 30.06.2024.
//

import SwiftUI

struct PatternsView: View {

    var body: some View {
//        ScrollView {
//            VStack(alignment: .center) {
//                Rectangle()
//                    .frame(width: 300, height: 300)
//                    .simpleGrid()
//                Rectangle()
//                    .frame(width: 300, height: 300)
//                    .rhombus()
                Rectangle()
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
//                    .frame(width: 300, height: 300)
                    .bricks()
//            }
//        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


extension View {
    func simpleGrid() -> some View {
        modifier(SimpleGridModifier())
    }

    func rhombus() -> some View {
        modifier(RhombusModifier())
    }

    func bricks() -> some View {
        modifier(BricksModifier())
    }
}

struct SimpleGridModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.simple_grid(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

struct RhombusModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.rhombus(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

struct BricksModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.bricks(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

#Preview {
    PatternsView()
}
