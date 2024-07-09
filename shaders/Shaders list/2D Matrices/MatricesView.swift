//
//  MatricesView.swift
//  Shaders
//
//  Created by tikhonov on 29.06.2024.
//

import SwiftUI

struct MatricesView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Rectangle()
                    .frame(width: 300, height: 300)
                    .plus()
                Rectangle()
                    .frame(width: 300, height: 300)
                    .plusRotation()
                Rectangle()
                    .frame(width: 300, height: 300)
                    .plusScale()
                Rectangle()
                    .frame(width: 300, height: 300)
                    .YUV()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}


extension View {
    func plus() -> some View {
        modifier(PlusModifier())
    }

    func plusRotation() -> some View {
        modifier(PlusRotationModifier())
    }

    func plusScale() -> some View {
        modifier(PlusScaleModifier())
    }

    func YUV() -> some View {
        modifier(YUVModifier())
    }
}

struct PlusModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.plus(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

struct PlusRotationModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.plus_rotation(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

struct PlusScaleModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.plus_scale(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}

struct YUVModifier: ViewModifier {

    @State var date = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.YUV(.float2(proxy.size), .float(date.timeIntervalSinceNow)))
                }
        }
    }
}


#Preview {
    MatricesView()
}
