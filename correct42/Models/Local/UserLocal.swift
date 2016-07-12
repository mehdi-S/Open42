//
//  UserLocal.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Foundation
import CoreData


class UserLocal: NSManagedObject {

	/**
	Implement with an user from 42 Api in an object and check if he's already exist in CoreData with his id index. If he does, update the row otherwise create it. In both return the coreData Object implemented.
	
	```
	let context = UIApplication.sharedApplication().managedObjectContext
	let myFriend = Friend.from(userDisplayed, userLogin)
	context.save() // Save the object in coreData
	```
	
	- Parameter user: User 42Api Object must have a valid index *id*
	- Parameter context: Data Friend context for CoreData
	- Returns: optionnal Friend object in context passed in parameter.
	*/
	class func from(currentLogguedUserApi:User,inFriendContext context: NSManagedObjectContext) -> UserLocal? {
		if currentLogguedUserApi.id != 0{
			let request = NSFetchRequest(entityName: "UserLocal")
			request.predicate = NSPredicate(format: "id = %i", currentLogguedUserApi.id)
			if let userLocal = (try? context.executeFetchRequest(request))?.first as? UserLocal {
				return userLocal
			} else if let userLocal = NSEntityDescription.insertNewObjectForEntityForName("UserLocal", inManagedObjectContext: context) as? UserLocal
			{
				userLocal.id = currentLogguedUserApi.id
				return (userLocal)
			}
		}
		return nil
	}
}
