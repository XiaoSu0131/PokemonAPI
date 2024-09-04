//
//  APIManager.swift
//  PokemonTemplate
//
//  Created by Chang on 09/01/2024
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
        guard let url = URL(string: "\(baseURL)?limit=50") else {
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
    
    // Fetch detailed data of a specific Pokémon
    func getPokemonData(for pokemonName: String, completion: @escaping (PokemonDetail?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(pokemonName.lowercased())") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            // Parsing the JSON data
            do {
                let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(pokemonDetail)
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                completion(nil)
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

struct PokemonDetail: Codable {
    let name: String
    let sprites: Sprites
    let types: [TypeEntry]
    let stats: [StatEntry]
}

struct Sprites: Codable {
    let front_default: String
}

struct TypeEntry: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct StatEntry: Codable {
    let stat: Stat
    let base_stat: Int
}

struct Stat: Codable {
    let name: String
}
