//
//  Pixel.swift
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

import SwiftUI

struct PixelView: View {

    var body: some View {
        Image("mountain")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(.system(size: 100))
            .pixellationShader(pixelSize: 4)
    }
}

extension View {
    func pixellationShader(pixelSize: CGFloat) -> some View {
        modifier(PixellationShader(pixelSize: pixelSize))
    }
}

struct PixellationShader: ViewModifier {

    let pixelSize: CGFloat
    var startDate = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content
                .layerEffect(
                    ShaderLibrary.pixellation(
                        .float(pixelSize),
                        .float(startDate.timeIntervalSinceNow)
                    ),
                    maxSampleOffset: CGSize(width: 100, height: 0)
                )
        }
    }
}

#Preview {
    PixelView()
}
