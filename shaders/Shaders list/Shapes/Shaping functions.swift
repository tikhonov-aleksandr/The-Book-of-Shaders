//
//  Shaping functions.swift
//  Shaders
//
//  Created by tikhonov on 07.07.2024.
//

import SwiftUI

extension View {
    func greenLine(plotFunction: PlotFunction) -> some View {
        modifier(GreenLine(plotFunction: plotFunction))
    }
}

struct GreenLine: ViewModifier {

    let plotFunction: PlotFunction

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(
                        ShaderLibrary.green_line(
                            .float2(proxy.size),
                            .float(plotFunction.funcNumber)
                        )
                    )
            }
    }
}
