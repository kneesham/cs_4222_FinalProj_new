//
//  SearchView.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/5/20.
//

import SwiftUI
import Combine

struct SearchView: View {

    @State var isTwoPart = false
    @State var jokeCategory: String = "Programming"
    @State var jokeSubstring: String = ""
    @State var jokeQuantity: Double = 2
    @State var numberOfParts: String = "single"


    private let searchQuery: String = "https://sv443.net/jokeapi/v2/joke/"
    private let jokeCategories = [ "Programming", "Miscellaneous", "Pun", "Christmas"]
    private let jokeParts = ["single", "twopart"]
    private let blackListed = "blacklistFlags=nsfw,religious,racist,sexist"

    var body: some View {

            VStack(alignment: .leading, spacing: 0) {
                Form {
                    Group {
                        Section {

                            TextField("Substring (optional)", text: $jokeSubstring)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Section {
                            Picker("Joke Category: ", selection: $jokeCategory){
                                ForEach(jokeCategories, id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                        Section {
                            Text("Quantity of jokes returned \(Int(jokeQuantity))")
                            Slider(value: $jokeQuantity, in: 2...10, step: 1.0)
                        }

                        Section {
                            Picker("Joke Category: ", selection: $numberOfParts){
                                ForEach(jokeParts, id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                    }
                    NavigationLink(destination: SearchResults(searchString: "\(searchQuery + jokeCategory)?\(blackListed)&type=\(numberOfParts)&contains=\(jokeSubstring)&amount=\(jokeQuantity)", shouldGetTwoParts: numberOfParts == "single" ? false : true)) {

                        HStack{
                            Spacer()
                            Text("See Results")
                            Spacer()
                        }
                    }

                    .foregroundColor(.black)
                }
                Spacer()
            }
            .navigationTitle("Search The JokeAPI!")
            .onAppear {
            }
        }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
