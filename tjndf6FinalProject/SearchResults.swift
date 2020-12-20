//
//  SearchResults.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/6/20.
//

import SwiftUI

struct SearchResults: View {

    var searchString: String
    var shouldGetTwoParts: Bool
    @State var jokes: [SinglePartJoke] = []
    @State var twoPartJokes: [TwoPartJoke] = []

    var body: some View {

        if shouldGetTwoParts {
            List(twoPartJokes) { joke in
                VStack(alignment:.leading) {
                    HStack {
                        FlippableJokeCard(setup: joke.setup, delivery: joke.delivery)
                        Spacer()
                    }

                }.padding(0)
                .layoutPriority(100)

            }.onAppear {
                JokeAPI().getAllTwoPartJokes(query: searchString) { (twoPartJokes) in
                    self.twoPartJokes = twoPartJokes.jokes
                }
            }.navigationTitle("Search Results!")

        } else {
            List(jokes) { joke in
                VStack(alignment:.leading) {
                    HStack {
                        JokeCard(joke: joke.joke)
                        Spacer()
                    }

                }
                .padding(0)
                .layoutPriority(100)

            }
            .onAppear {
                JokeAPI().getAllSingleJokes(query: searchString) { (singleJokes) in
                    self.jokes = singleJokes.jokes
                }
            }.navigationTitle("Search Results!")
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults(searchString: "https://sv443.net/jokeapi/v2/joke/Any?type=single&amount=10", shouldGetTwoParts: false)
    }
}
