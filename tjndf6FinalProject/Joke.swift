//
//  Joke.swift
//  TedNesham_final
//
//  Created by Ted Nesham on 12/16/20.
//

import Foundation

struct TwoPartJoke: Codable, Identifiable {

    var id = UUID()
    var category: String
    var type: String
    var setup: String
    var delivery: String

    private enum CodingKeys: String, CodingKey {
        case setup, delivery, category, type
    }
}

struct SinglePartJoke: Codable, Identifiable {
    var id = UUID()
    var category: String
    var type: String
    var joke: String


    private enum CodingKeys: String, CodingKey {
        case joke, category, type
    }
}

struct TwoPartJokes: Codable, Identifiable {
    var id = UUID()
    var jokes: [TwoPartJoke]

    private enum CodingKeys: String, CodingKey {
        case jokes
    }
}

struct SingleJokes: Codable, Identifiable {
    var id = UUID()
    var jokes: [SinglePartJoke]

    private enum CodingKeys: String, CodingKey {
        case jokes
    }
}
