//
//  DetailHeader.swift
//  SwiftPokeDex
//
//  Created by Uziel Sabalza on 10/8/26.
//

import SwiftUI

struct DetailHeader: View {
    let pokemon: PokemonDetail
    
    private var mainType: String {
        pokemon.types.first?.type.name ?? "normal"
    }
    
    private var artworkURL: URL? {
        if let urlString = pokemon.sprites.other.officialArtwork.frontDefault {
            return URL(string: urlString)
        }
        return nil
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [
                    TypeColor(rawValue: mainType)?.color ?? .gray,
                    TypeColor(rawValue: mainType)?.color.opacity(0.6) ?? .gray.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedCornerShape(radius: 40, corners: [.bottomLeft, .bottomRight]))
            .frame(height: 260)
            Text(String(format: "#%03d", pokemon.id))
                .font(.system(size: 100, weight: .black))
                .foregroundColor(.white.opacity(0.15))
                .offset(y: -40)
            
            AsyncImage(url: artworkURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
            } placeholder: {
                ProgressView()
                    .tint(.white)
                    .frame(width: 220, height: 220)
            }
            .offset(y: 30)
        }
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
