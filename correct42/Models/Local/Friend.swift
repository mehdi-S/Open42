//
//  Friend.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Foundation
import CoreData


class Friend: NSManagedObject {

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
	class func from(userApi:User, forThe currentUserApi:User, inFriendContext context: NSManagedObjectContext) -> Friend? {
		if userApi.id != 0 && currentUserApi.id != 0{
			let request = NSFetchRequest(entityName: "Friend")
			request.predicate = NSPredicate(format: "id = %i && user.id = %i", userApi.id, currentUserApi.id)
			if let friend = (try? context.executeFetchRequest(request))?.first as? Friend {
				friend.imageUrl = userApi.imageUrl
				friend.location = userApi.location
				friend.phoneNumber = userApi.phone
				return friend
			} else if let friend = NSEntityDescription.insertNewObjectForEntityForName("Friend", inManagedObjectContext: context) as? Friend
			{
				friend.user = UserLocal.from(currentUserApi, inFriendContext: context)
				friend.id = userApi.id
				friend.email = userApi.email
				friend.location = userApi.location
				friend.phoneNumber = userApi.phone
				friend.login = userApi.login
				friend.imageUrl = userApi.imageUrl
				return (friend)
			}
		}
		return nil
	}
	
}
