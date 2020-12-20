//
//  JOTDView.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/5/20.
//

import SwiftUI

struct RandomJokeView: View {

    @StateObject var viewModelRandom = JokeAPI()
    @State var flipped = false
    @State var getSingle = Bool.random()

    var body: some View {
        ZStack {

            LinearGradient(
                gradient: Gradient(colors: [.red, .orange, .yellow, .white]),
                startPoint: .bottom,
                endPoint: .top

            ).ignoresSafeArea()

            VStack {

                if getSingle {
                    Text("Tap for punchline!")
                        .font(.title)

                    FlippableJokeCard(setup: viewModelRandom.twoPartedRandom.setup, delivery: viewModelRandom.twoPartedRandom.delivery)
                }

                else {
                    JokeCard(joke: viewModelRandom.singlePartRandom.joke)
                }

            }
        }
        .navigationTitle("Random Joke Generator!")
        .onAppear {
            self.getSingle = Bool.random()
        }
    }
}

struct JOTDView_Previews: PreviewProvider {
    static var previews: some View {
        RandomJokeView()
    }
}


