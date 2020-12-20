//
//  ContentView.swift
//  TedNesham_final
//
//  Created by Ted Nesham on 12/14/20.
//

import SwiftUI

struct MainView: View {
    var body: some View {

        NavigationView {

            VStack {

                Group {

                    NavigationLink(destination: RandomJokeView()) {
                        Card(title: "Get a Random Joke!", color: Color.blue.opacity(0.75))
                    }.foregroundColor(.black)

                    NavigationLink(destination: SearchView()) {
                        Card(title: "Search For Jokes!", color: Color.orange.opacity(0.75))
                    }.foregroundColor(.black)

                    NavigationLink(destination: FavoritesView()) {
                        Card(title: "My Favorite Jokes!", color: Color.pink.opacity(0.75))
                    }.foregroundColor(.black)

                    NavigationLink(destination: SendView()) {
                        Card(title: "Send a Joke!", color: Color.green.opacity(0.75))
                    }.foregroundColor(.black)
                }
                .padding()
                Spacer()
            }
            .navigationTitle("The Joke App!")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .white]), startPoint: .bottom, endPoint: .top).ignoresSafeArea())


        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct Card: View {

    var title: String
    var color: Color
    var cardColor = Color.init(red: (43/255), green: (43/255), blue: (43/255))
    var textColor = Color.init(red: (102/255), green: 1, blue: (204/255))

    var body: some View {

        HStack {
            Spacer()
            Text(title)
                .frame(width: 250, height: 120, alignment: .center)
                .border(Color.black, width: 3)
                .cornerRadius(5)
                .foregroundColor(textColor)
                .background(cardColor)
                .aspectRatio(contentMode: ContentMode.fit)
            Spacer()
        }.shadow(radius: 2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
