//
//  JokeCards.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/11/20.
//

import SwiftUI
import CoreData
import MobileCoreServices

extension View {

    func flipRotate(_ degrees : Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: 1.0, y: 0.0, z: 0.0))
    }

    func placedOnCard(_ color: Color) -> some View {
        return padding(5).frame(width: 250, height: 150, alignment: .center).background(color)
    }
}

struct FlippableJokeCard: View {

    @Environment(\.managedObjectContext) var moc


    @State var flipped = false
    var setup: String
    var delivery: String
    var isFavorited: Bool = false
    var cardColor = Color.init(red: (43/255), green: (43/255), blue: (43/255))
    var buttonColor = Color.init(red: (151/255), green: (84/255), blue: (238/255))
    var flipperColor = Color.init(red: (102/255), green: 1, blue: (204/255))

    var body: some View {

        let flipDegrees = flipped ? 180.0 : 0

        VStack(alignment:.leading) {

            HStack {
                Spacer()
                ZStack() {
                    Text(setup).placedOnCard(flipperColor).flipRotate(flipDegrees).opacity(flipped ? 0.0 : 1.0)
                    Text(delivery).placedOnCard(flipperColor).flipRotate(-180 + flipDegrees).opacity(flipped ? 1.0 : 0.0)
                }
                .animation(.easeInOut(duration: 0.8))
                .onTapGesture { self.flipped.toggle() }
                .shadow(radius: 5)
                Spacer()
            }
            .padding()

            HStack(spacing: 25) {
                // Buttons
                Button(action: {
                    do {
                        let favoritedJoke = FavoriteTwoPart(context: self.moc)
                        favoritedJoke.setup = self.setup
                        favoritedJoke.delivery = self.delivery

                        try self.moc.save()
                        print("Favorite (two part)")
                    } catch {
                        print(error)
                    }

                }, label: {
                    HStack {
                        Text("Favorite")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(buttonColor)
                    .cornerRadius(15)
                    .frame(width: 100, height: 75, alignment: .center)
                })
                .disabled(isFavorited)
                .buttonStyle(PlainButtonStyle())


                ShareButton(shareString: "\(self.setup)\n.\n.\n.\n\(self.delivery)")
                CopyButton(jokeString: "\(self.setup)\n.\n.\n.\n\(self.delivery)")

            }
        }
        .background(cardColor)
        .cornerRadius(5)

    }
}

struct JokeCard: View {

    @Environment(\.managedObjectContext) var moc

    var joke: String
    var isFavorited: Bool = false
    var cardColor = Color.init(red: (43/255), green: (43/255), blue: (43/255))
    var textColor = Color.init(red: (102/255), green: 1, blue: (204/255))
    var buttonColor = Color.init(red: (151/255), green: (84/255), blue: (238/255))

    var body: some View {

        VStack(alignment:.leading) {

            HStack {
                Spacer()
                Text(joke)
                    .foregroundColor(textColor)
                    .padding()
                Spacer()
            }
            .animation(.easeInOut(duration: 0.8))


            HStack(spacing: 25) {
                // Buttons
                Button(action: {
                    // Save the joke to the favorites here

                    do {
                        let favoritedJoke = Favorite(context: self.moc)
                        favoritedJoke.joke = self.joke

                        try self.moc.save()
                        print("Favorite")
                    } catch {
                        print(error)
                    }


                }, label: {
                    HStack {
                        Text("Favorite")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(buttonColor)
                    .cornerRadius(15)
                    .frame(width: 100, height: 75, alignment: .center)
                })
                .buttonStyle(PlainButtonStyle())
                .disabled(isFavorited)


                ShareButton(shareString: joke)
                CopyButton(jokeString: self.joke)

            }
        }
        .background(cardColor)
        .cornerRadius(5)
    }
}


struct ShareButton: View {
    @State var isShareSheetShowing = false
    var shareString: String
    var buttonColor = Color.init(red: (151/255), green: (84/255), blue: (238/255))

    var body: some View {
        Button(action: {
            isShareSheetShowing.toggle()
            let av = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
            print("Share")
        }, label: {
            HStack {
                Text("Share")
                    .fontWeight(.semibold)
            }
            .padding()
            .foregroundColor(.white)
            .background(buttonColor)
            .cornerRadius(15)
            .frame(width: 100, height: 75, alignment: .center)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct CopyButton: View {

    var buttonColor = Color.init(red: (151/255), green: (84/255), blue: (238/255))
    var jokeString: String

    var body: some View {
        Button(action: {
            print("Copy")

            UIPasteboard.general.setValue(jokeString, forPasteboardType: kUTTypePlainText as String)

        }, label: {

            HStack {
                Text("Copy")
                    .fontWeight(.semibold)
            }
            .padding()
            .foregroundColor(.white)
            .background(buttonColor)
            .cornerRadius(15)
            .frame(width: 100, height: 75, alignment: .center)

        })
        .buttonStyle(PlainButtonStyle())
    }
}
