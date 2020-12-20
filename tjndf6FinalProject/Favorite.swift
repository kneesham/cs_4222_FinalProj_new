//
//  Favorite.swift
//  TedNesham_final
//
//  Created by Ted Nesham on 12/14/20.
//

import Foundation
import CoreData

@objc(Favorite)

class Favorite: NSManagedObject, Identifiable {

    @NSManaged public var joke: String?
}

extension Favorite {
    static func getAllFavorites() -> NSFetchRequest<Favorite> {
        let req: NSFetchRequest<Favorite> = Favorite.fetchRequest() as! NSFetchRequest<Favorite>

        let sortDescriptor = NSSortDescriptor(key: "joke", ascending: true)

        req.sortDescriptors = [sortDescriptor]

        return req
    }
}

