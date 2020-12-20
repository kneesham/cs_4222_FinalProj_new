//
//  FavoriteTwoPart.swift
//  TedNesham_final
//
//  Created by Ted Nesham on 12/14/20.
//

import Foundation
import CoreData

@objc(FavoriteTwoPart)

class FavoriteTwoPart: NSManagedObject, Identifiable {

    @NSManaged public var setup: String?
    @NSManaged public var delivery: String?
}


extension FavoriteTwoPart {
    static func getAllFavorites() -> NSFetchRequest<FavoriteTwoPart> {
        let req: NSFetchRequest<FavoriteTwoPart> = FavoriteTwoPart.fetchRequest() as! NSFetchRequest<FavoriteTwoPart>
        let sortDescriptor = NSSortDescriptor(key: "setup", ascending: true)
        req.sortDescriptors = [sortDescriptor]

        return req
    }
}
