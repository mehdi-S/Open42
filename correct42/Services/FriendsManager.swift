//
//  FriendsManager.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//
import CoreData
import UIKit

class FriendsManager {
	// MARK: Singleton
	/// Static Instance of the FriendsManager
	static let sharedInstance = FriendsManager()
	
	
	/**
	Give the singleton object of the FriendsManager
	
	```
	let friendsManager = FriendsManager.Shared()
	```
	
	- returns: `static let instance`
	*/
	static func Shared() -> FriendsManager
	{
		return (self.sharedInstance)
	}
	
	// MARK: - Singletons
	/// Singleton of `UserManager`
	let userManager = UserManager.Shared()
	/// Singleton of `ApiRequester`
	let apiRequester = ApiRequester.Shared()
	
	/// CoreData context FriendsDB
	lazy var context:NSManagedObjectContext = {
		return ((UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext)
	}()!
	
	/**
	Need to define a delegate in view with a tableview to work
	*/
	lazy var fetchedResults:NSFetchedResultsController = {
		// Initialize Fetch Request
		let fetchRequest = NSFetchRequest(entityName: "Friend")
		fetchRequest.predicate = NSPredicate(format: "user.id = %i", self.userManager.loginUser!.id)
		// Add Sort Descriptors
		let sortDescriptor = NSSortDescriptor(key: "login", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		// Initialize Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
		return fetchedResultsController
	}()
	
	var list:[Friend]?{
		get {
			return fetchedResults.fetchedObjects as? [Friend]
		}
	}
	
	func exist(searchedUser:User) -> Bool {
		if let students = list {
			for student in students {
				if student.id == searchedUser.id {
					return true
				}
			}
		}
		return false
	}
	
	func add(friendUser:User, forThe currentUser:User, onCompletion:(NSError?)->Void){
		context.performBlockAndWait{
			let friend = Friend.from(friendUser, forThe: currentUser, inFriendContext: self.context)
			if friend != nil {
				do {
					try self.context.save()
					try self.fetchedResults.performFetch()
					onCompletion(nil)
				} catch(let error) {
					onCompletion(NSError(domain:"CoreData", code: -1, userInfo: ["message":"Erreur on CoreData : \(error)"]))
				}
			} else {
				onCompletion(NSError(domain:"Friends", code: 0, userInfo: ["message":"Error on adding friend."]))
			}
		}
	}
	
	func remove(friendUser:Friend){
		context.performBlockAndWait{
			NSFetchedResultsController.deleteCacheWithName(nil)
			self.context.deleteObject(friendUser as NSManagedObject)
			
			do{
				try self.context.save()
				try self.fetchedResults.performFetch()
			} catch let error {
				print("\(error)")
			}
		}
	}
	
	func refresh(currentUser:User, onCompletion:(NSError?)->Void){
		if let friends = list where list?.count > 0 {
			// Recurcivity pop and completion at end.
			var usersId = [Int]()
			for friend in friends {
				if let userId = friend.id as? Int {
					usersId.append(userId)
				}
			}
			refreshProcess(usersId, currentUser: currentUser, onCompletion: onCompletion)
		} else {
			onCompletion(nil)
		}
	}

	private func refreshProcess(usersId:[Int], currentUser:User, onCompletion:(NSError?)->Void){
		var usersIdCpy = usersId
		apiRequester.request(UserRouter.ReadUser(usersIdCpy.popLast()! as Int)) {
			(jsonDataOpt, errorOpt) in
			if let jsonRow = jsonDataOpt {
					let friendUser = User(jsonFetch:jsonRow)

					guard (Friend.from(friendUser, forThe: currentUser, inFriendContext: self.context) != nil) else {
						onCompletion(NSError(domain:"Friends", code: 0, userInfo: ["message":"Error on refresh friend."]))
						return
					}
					do {
						if (usersIdCpy.count > 0) {
							self.refreshProcess(usersIdCpy, currentUser: currentUser, onCompletion: onCompletion)
						} else {
							try self.context.save()
							try self.fetchedResults.performFetch()
							onCompletion(nil)
						}
					} catch(let error) {
						onCompletion(NSError(domain:"CoreData", code: -1, userInfo: ["message":"Erreur on CoreData : \(error)"]))
						return
					}
			}
			if let error = errorOpt {
				onCompletion(error)
			}
		}
	}
}