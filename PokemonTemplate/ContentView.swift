//
//  ContentView.swift
//  PokemonTemplate
//
//  Created by Mark Kinoshita on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var apiManager = APIManager()
    var body: some View {
        NavigationView {
            List(apiManager.pokemons, id: \.self) { pokemon in
                Text(pokemon.capitalized)
            }
            .onAppear {
                apiManager.fetchPokemons()
            }
            .navigationTitle("Pokémon List")
        }
    }
}

#Preview {
    ContentView()
}
