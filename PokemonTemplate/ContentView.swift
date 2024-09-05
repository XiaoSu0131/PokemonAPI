//
//  ContentView.swift
//  PokemonTemplate
//
//  Created by Chang on 8/30/24.
//

import SwiftUI

struct ContentView: View {
    @State var apiManager = APIManager()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredPokemons, id: \.self) { pokemon in
                NavigationLink(destination: PokemonDetails(pokemonName: pokemon)) {
                    HStack {
                        // Display Pokemon's Sprite
                        PokemonSprite(imageLink: pokemon)
                        
                        // Display Pokemon's Name
                        Text(pokemon.capitalized)
                            .padding(.trailing, 20)
                    }
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

