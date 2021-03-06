//
//  Friend+CoreDataProperties.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Friend {

    @NSManaged var email: String?
    @NSManaged var id: NSNumber?
    @NSManaged var location: String?
    @NSManaged var login: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var surname: String?
    @NSManaged var imageUrl: String?
    @NSManaged var user: UserLocal?

}
