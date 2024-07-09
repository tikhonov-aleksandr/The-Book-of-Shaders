//
//  ColorShaderListView.swift
//  Shaders
//
//  Created by tikhonov on 25.05.2024.
//

import SwiftUI

struct ShaderListView: View {

    var body: some View {
        NavigationStack() {
            List {
                ForEach(ShaderEntry.allCases) { entry in
                    NavigationLink(value: Destination.shader(shaderEntry: entry)) {
                        Text(entry.name)
                    }
                }
            }
            .navigationTitle("Shaders")
            .navDestination()
        }
    }
}

#Preview {
    ShaderListView()
}
