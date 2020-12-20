//
//  FavoritesView.swift
//  tjndf6_FinalProject
//
//  Created by Ted Nesham on 12/5/20.
//

import SwiftUI
import CoreData

struct FavoritesView: View {

    var body: some View {
        VStack {
            List {
                SingleJokesList()
                TwoPartJokesList()
            }
        }
    }
}

struct SingleJokesList: View {

    @Environment(\.managedObjectContext)
    var moc

    @FetchRequest(fetchRequest: Favorite.getAllFavorites())
    var favorites: FetchedResults<Favorite>
    var body: some View {

        Text("Single part jokes").font(.title)
        if self.favorites.count == 0 {
            Text("You currently have no favorites. Add some.")
        }

        ForEach(self.favorites) { favorite in
            JokeCard(joke: favorite.joke ?? "", isFavorited: true)
        }
        .onDelete { indexSet in
            for index in indexSet {
                moc.delete(favorites[index])
            }
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct TwoPartJokesList: View {

    @Environment(\.managedObjectContext)
    var moc

    @FetchRequest(fetchRequest: FavoriteTwoPart.getAllFavorites())
    var favorites: FetchedResults<FavoriteTwoPart>

    var body: some View {

        Text("Two part jokes").font(.title)
        if self.favorites.count == 0 {
            Text("You currently have no favorites. Add some.")
        }

        ForEach(self.favorites) { favorite in

            FlippableJokeCard(setup: favorite.setup ?? "Default", delivery: favorite.delivery ?? "Default", isFavorited: true)
        }
        .onDelete { indexSet in
            for index in indexSet {
                moc.delete(favorites[index])
            }
            do {
                try moc.save()
            } catch {
                print(error.localizedDescription)
            }
        }

    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
