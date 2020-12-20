//
//  Joke.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/5/20.
//

import SwiftUI
import Foundation
import Combine

final class JokeAPI: ObservableObject {

    private var twoPartCancellable: AnyCancellable?
    private var singlePartCancellable: AnyCancellable?

    @Published var singlePartRandom = SinglePartJoke(category: "", type: "", joke: "")
    @Published var twoPartedRandom = TwoPartJoke(category: "", type: "", setup: "", delivery: "" )

    init() {
        getSingleRandom()
        getTwoPartRandom()
    }

    func getSingleRandom() {

        guard
            let url = URL(string: "https://sv443.net/jokeapi/v2/joke/Programming,Miscellaneous,Pun,Spooky,Christmas?blacklistFlags=nsfw,religious,political,racist,sexist&type=single")
        else { return }

        self.singlePartCancellable = URLSession.shared.dataTaskPublisher(for: url)

            .tryMap { (data, res) in
                guard let httpRes = res as? HTTPURLResponse,
                      httpRes.statusCode == 200 else {
                    print("bad req")
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: SinglePartJoke.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

            .sink(receiveCompletion: {_ in
            }, receiveValue: { joke in
                self.singlePartRandom = joke
            })
    }

    func getTwoPartRandom() {

        guard
            let url = URL(string: "https://sv443.net/jokeapi/v2/joke/Programming,Miscellaneous,Pun,Spooky,Christmas?blacklistFlags=nsfw,religious,political,racist,sexist&type=twopart")
        else { return }

        self.twoPartCancellable = URLSession.shared.dataTaskPublisher(for: url)

            .tryMap { (data, res) in
                guard let httpRes = res as? HTTPURLResponse,
                      httpRes.statusCode == 200 else {
                    print("bad req")
                    return data
                }
                return data
            }
            .decode(type: TwoPartJoke.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in}, receiveValue: { joke in
                self.twoPartedRandom = joke
            })
    }

    func getAllSingleJokes(query: String , completion: @escaping (SingleJokes) -> () ) {
        guard
            let url = URL(string: query)
        else { return }

        URLSession.shared.dataTask(with: url) { (data,_ ,_) in

            do {
                let jokes = try JSONDecoder().decode(SingleJokes.self, from: data!)
                DispatchQueue.main.async {
                    completion(jokes)
                }
            }
            catch {
                print("url could not be decoded, either because the json did not match a 'single joke'")
                let joke = SinglePartJoke(category: "NA", type: "NA", joke: "NO JOKE FOUND")
                let jokes = SingleJokes(jokes: [joke])

                DispatchQueue.main.async {
                    completion(jokes)
                }
            }
        }
        .resume()
    }

    func getAllTwoPartJokes(query: String, completion: @escaping (TwoPartJokes) -> ()) {

        guard
            let url = URL(string: query)
        else { return }

        URLSession.shared.dataTask(with: url) { (data,_ ,_) in

            do {
                let jokes = try JSONDecoder().decode(TwoPartJokes.self, from: data!)

                DispatchQueue.main.async {
                    completion(jokes)
                }
            } catch {
                print("no matching jokes \(error)")

                let twoPartJoke = TwoPartJoke(category: "", type: "", setup: "NO", delivery: "JOKE FOUND")
                let twoPartJokes = TwoPartJokes(jokes: [twoPartJoke])

                DispatchQueue.main.async {
                    completion(twoPartJokes)
                }
            }
        }
        .resume()
    }
}
