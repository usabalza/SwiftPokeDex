//
//  StatsChart.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 11/8/26.
//

import SwiftUI
import Charts

struct StatsChart: View {
    let pokemon: PokemonDetail
    
    @State private var animateBars = false
    
    private var mainType: String {
        pokemon.types.first?.type.name ?? "normal"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Estadísticas Base")
                    .font(.title3)
                    .bold()
                Spacer()
                Text("Total: \(pokemon.baseStatTotal)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            
            // 📊 CONSTRUCCIÓN DEL GRÁFICO CON SWIFTCHARTS
            Chart(pokemon.chartStats) { stat in
                // Graficamos barras horizontales asignando el valor a 'x' y la categoría a 'y'
                BarMark(
                    x: .value("Puntos", stat.value),
                    y: .value("Estadística", stat.name)
                )
                .foregroundStyle(TypeColor(rawValue: mainType)?.color.gradient ?? Color.gray.gradient) // Color dinámico con gradiente nativo
                .cornerRadius(6)
                // Añadimos etiquetas numéricas al final de cada barra
                .annotation(position: .trailing, alignment: .leading) {
                    Text("\(stat.value)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }
            }
            .chartXScale(domain: 0...255) // Rango oficial máximo de un Stat en Pokémon
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading) { _ in
                    AxisValueLabel()
                        .font(.footnote)
                }
            }
            .chartXAxis(.hidden) // Ocultamos el eje numérico inferior para un diseño más limpio
            .frame(height: 200)
            // 🪄 EFECTO DE ANIMACIÓN: Escalamos horizontalmente de 0 a 1
            .scaleEffect(x: animateBars ? 1.0 : 0.0, y: 1.0, anchor: .leading)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .onAppear {
            // Disparamos la animación con un resorte suave al abrir la pantalla
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0)) {
                animateBars = true
            }
        }
    }
}
