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
            List(searchPokemon, id: \.self) { pokemon in
                HStack{
                    // Placeholder for the Pokemon Sprite next to each name in view
                    Circle().frame(width: 50, height: 50)
                    Text(pokemon.capitalized).padding(.trailing, 20)
                }
            }
            .onAppear {
                apiManager.fetchPokemons()
            }
            .navigationTitle("Pokémon List")
            .searchable(text: $searchText)
        }
    }
    
    private var searchPokemon: [String] {
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

