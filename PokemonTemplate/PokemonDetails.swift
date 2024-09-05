//
//  PokemonDetails.swift
//  PokemonTemplate
//
//  Created by Chang Su on 8/30/24.
//

import SwiftUI

struct PokemonDetails: View {
    let pokemonName: String
    @State private var pokemonDetail: PokemonDetail?
    
    var body: some View {
        VStack {
            if let detail = pokemonDetail {
                // Display the sprite
                AsyncImage(url: URL(string: detail.sprites.front_default)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } placeholder: {
                    ProgressView()
                }
                
                // Display Pokémon's name
                Text(detail.name.capitalized)
                    .font(.largeTitle)
                    .padding()
                
                // Display Type
                VStack(alignment: .leading) {
                    Text("Type")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        ForEach(detail.types, id: \.type.name) { typeEntry in
                            Text(typeEntry.type.name.capitalized)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.vertical)
                
                // Display Stats
                VStack(alignment: .leading) {
                    Text("Stats:")
                        .font(.headline)
                        .padding()
                    
                    ForEach(detail.stats, id: \.stat.name) { stat in
                        HStack {
                            Text(stat.stat.name.capitalized)
                            Spacer()
                            Text("\(stat.base_stat)")
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical)
                
            } else {
                // Show a loading indicator while fetching data
                ProgressView()
                    .onAppear {
                        fetchPokemonDetail()
                    }
            }
        }
        .navigationTitle(pokemonName.capitalized)
        .padding()
    }
    
    private func fetchPokemonDetail() {
        APIManager().getPokemonData(for: pokemonName) { detail in
            DispatchQueue.main.async {
                self.pokemonDetail = detail
            }
        }
    }
}

struct PokemonDetails_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetails(pokemonName: "pikachu")
    }
}


