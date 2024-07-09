//
//  ShaderEntry.swift
//  Shaders
//
//  Created by tikhonov on 16.06.2024.
//

import Foundation

enum ShaderEntry: String, CaseIterable, Identifiable {

    var id: Self { self }

    case shape
    case gradient
    case pixel
    case loupe
    case patters

    var name: String {
        switch self {
        case .shape:
            "Shape"
        case .gradient:
            "Gradient"
        case .pixel:
            "Pixellation"
        case .loupe:
            "Loupe"
        case .patters:
            "Patterns"
        }
    }
}

