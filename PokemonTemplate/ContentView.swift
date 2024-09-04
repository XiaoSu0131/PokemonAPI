//
//  ContentView.swift
//  PokemonTemplate
//
//  Created by Mark Kinoshita on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var apiManager = APIManager()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredPokemons, id: \.self) { pokemon in
                HStack {
                    // Use PokemonSprite here with the Pokémon's name
                    PokemonSprite(imageLink: pokemon) // Passing the Pokémon name as the imageLink
                    
                    Text(pokemon.capitalized)
                        .padding(.trailing, 20)
                }
            }
            .onAppear {
                apiManager.fetchPokemons()
            }
            .navigationTitle("Pokémon List")
            .searchable(text: $searchText)
        }
    }
    
    private var filteredPokemons: [String] {
        if searchText.isEmpty {
            return apiManager.pokemons
        } else {
            return apiManager.pokemons.filter { $0.contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ContentView()
}

