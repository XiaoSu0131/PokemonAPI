//
//  APIManager.swift
//  PokemonTemplate
//
//  Created by Mark Kinoshita on 8/13/24.
//

import Foundation

@Observable
class APIManager {
    
    // Base URL for the Pokémon API
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    
    // Observable list of Pokémon names
    var pokemons: [String] = []

    // Fetch list of Pokémon
    func fetchPokemons() {
        guard let url = URL(string: "\(baseURL)?limit=20") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Parsing the JSON data
            do {
                let jsonData = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.pokemons = jsonData.results.map { $0.name }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}

// Helper structs for JSON decoding
struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable {
    let name: String
    let url: String
}
