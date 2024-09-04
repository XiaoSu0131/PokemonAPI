//
//  PokemonSprite.swift
//  PokemonTemplate
//
//  Created by Chang on 8/30/24.
//

import SwiftUI

struct PokemonSprite: View {
    var imageLink: String
    @State private var pokemonSprite = ""
    
    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite))
            .frame(width: 75, height: 75)
            .onAppear {
                if let cachedSprite = UserDefaults.standard.string(forKey: imageLink) {
                    // Use cached sprite if available
                    pokemonSprite = cachedSprite
                } else {
                    // Fetch sprite if not cached
                    getSprite(for: imageLink)
                }
            }
    }
    
    func getSprite(for pokemonName: String) {
        APIManager().getPokemonData(for: pokemonName) { detail in
            guard let detail = detail else {
                // Handle error or set to a default placeholder
                return
            }
            // Save and update sprite
            let spriteURL = detail.sprites.front_default
            UserDefaults.standard.set(spriteURL, forKey: pokemonName)
            DispatchQueue.main.async {
                self.pokemonSprite = spriteURL
            }
        }
    }
}

struct PokemonSprite_Previews: PreviewProvider {
    static var previews: some View {
        // Previewing with a sample image link
        PokemonSprite(imageLink: "mewtwo") // Example Pokémon name
    }
}
