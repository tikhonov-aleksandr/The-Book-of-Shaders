//
//  Shaping functions.swift
//  Shaders
//
//  Created by tikhonov on 07.07.2024.
//

import SwiftUI

enum PlotFunction: Int, Identifiable, CaseIterable {

    var id: Self { self }

    case linear
    case quadratic
    case sine
    case cosine
    case exponential
    case logarithmic
    case absolute
    case reciprocal

    var name: String {
        switch self {
        case .linear:
            "y = x"
        case .quadratic:
            "y = x * x"
        case .sine:
            "y = sin(x)"
        case .cosine:
            "y = cos(x)"
        case .exponential:
            "y = exp(x)"
        case .logarithmic:
            "y = log(x)"
        case .absolute:
            "y = |x|"
        case .reciprocal:
            "y = 1 / x"
        }
    }

    var funcNumber: Float {
        Float(rawValue)
    }
}


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
