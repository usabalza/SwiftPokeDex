//
//  ShimmerModifier.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 6/8/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            // Usamos un gradiente con tres tonos de gris para simular el brillo
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color(.systemGray4),
                        Color(.systemGray5)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .mask(content) // El gradiente solo se dibuja sobre la forma del contenido original
                .offset(x: phase)
            )
            .onAppear {
                // Animación lineal continua e infinita
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300 // Distancia que recorre el brillo
                }
            }
    }
}

// Extensión para que sea muy fácil de usar en cualquier vista
extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
