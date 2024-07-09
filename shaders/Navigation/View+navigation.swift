//
//  View+navigation.swift
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

import SwiftUI

extension View {
    func navDestination() -> some View {
        navigationDestination(for: Destination.self) { destination in
            switch destination {
            case .shader(let entry):
                switch entry {
                case .gradient:
                    GradientView()
                case .loupe:
                    LoupeView()
                case .pixel:
                    PixelView()
                case .shape:
                    ShapesView()
                case .patters:
                    PatternsView()
                }
            }
        }
    }
}
