//
//  ScaleTeamsManager.swift
//  correct42
//
//  Created by larry on 15/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Foundation

/**
Contain the list of scaleTeams.
Permit to save scaleTeams to IOS Calendar.
*/
class ScaleTeamsManager {
	// MARK: Singleton
	/// Static Instance of the ScaleTeamsManager
	static let sharedInstance = ScaleTeamsManager()
	
	
	/**
	Give the singleton object of the ScaleTeamsManager
	
	```
	let scaleTeamsManager = ScaleTeamsManager.Shared()
	```
	
	- returns: `static let instance`
	*/
	static func Shared() -> ScaleTeamsManager
	{
		return (self.sharedInstance)
	}
	
	// MARK: - Proprieties
	/// List of the scales team
	lazy var list:[ScaleTeam] = [ScaleTeam]()
	let persistentKey = "addedScaleCalendarv1.0"
	
	// MARK: - Services
	/// Singleton of the API
	let apiRequester = ApiRequester.Shared()

	// MARK: - Methods
	/**
	Fetch api Token by asking it to the user with webview his ids and execute
	corresponding callback.
	
	```
	let scaleTeamsManager = ScaleTeamsManager.Shared()
	ScaleTeamsManager.fetchMyScaleTeams(success:
	{ (listScaleTeam) in
		print("Success !")
	}
	}) { (error) in
		print(error)
	}
	```
	
	- Parameters:
		- success: CallBack execute if the request success and take a `ScaleTeam` array in parameter.
		- failure: CallBack execute if the request fail.
	*/
	func fetchMyScaleTeams(success:([ScaleTeam])->Void, failure:(NSError)->Void){
		apiRequester.request(ScaleTeamsRouter.Me){ (jsonDataOpt, errorOpt) in
			if let error = errorOpt {
				failure(error)
			}
			else if let jsonData = jsonDataOpt {
				self.list.removeAll()
				for scaleInfos in jsonData.arrayValue {
					let scaleTeam = ScaleTeam(jsonFetch: scaleInfos)
					if (!self.idExist(scaleTeam.id)){
						self.list.append(scaleTeam)
					}
				}
				success(self.list)
			}
		}
	}
	
	/**
	Check in list of scaleTeam if an id exist
	
	- Parameters:
		- id: Id who we need to know if exist in the list of the scaleTeam.
	
	- Return: True if exist
	*/
	func idExist(id:Int) -> Bool {
		var result = false
		for scaleInfos in list{
			if (id == scaleInfos.id){
				result = true
			}
		}
		return (result)
	}
	
	/**
	Add an scaleTeam to the IOS calendar
	
	- Parameters:
		- scaleTeam: `ScaleTeam` model
		- onCompletion: Use (NSError?)->Void handler
	*/
	func addScaleTeamToCalendar(scaleTeam:ScaleTeam, onError:(NSError)->Void){
		let idScaleTeam = scaleTeam.id
		let startDate = scaleTeam.beginAt
		let scaleName = scaleTeam.scale.name.stringByReplacingOccurrencesOfString("-", withString: " ")
		
		if !self.persitentIdExist(idScaleTeam) {
			let endDate = scaleTeam.beginAt.dateByAddingTimeInterval(Double(scaleTeam.scale.duration))
			addEventToCalendar(title: scaleTeam.scale.name, description: "", startDate: startDate, endDate: endDate, onCompletion: { (success, error) in
				if (!success){
					onError(NSError(domain: "Corrections", code: 0, userInfo: ["message":"A problem happen when adding \(scaleName) \(scaleTeam.beginAtFormated) in calendar"]))
				} else {
					self.addPersitentId(idScaleTeam)
				}
			})
		} else {
			onError(NSError(domain: "Corrections", code: 0, userInfo: ["message":"Entry for \(scaleName) \(scaleTeam.beginAtFormated) already exist."]))
		}
	}
	
	/**
	Add all scaleTeams to the IOS calendar
	
	- Parameters:
	- scalesTeam: `ScaleTeam` array model
	- onCompletion: Use (NSError?)->Void handler
	*/
	func addScaleTeamsToCalendar(onErrorEntry:(NSError)->Void){
		cleanOldScaleTeamPersistentData()
		for curScaleTeam in list {
			addScaleTeamToCalendar(curScaleTeam, onError: onErrorEntry)
		}
	}
	
	/**
	Clean scaleTeam passed current date from persistent data
	*/
	func cleanOldScaleTeamPersistentData(){
		/// Singleton of the user persistent data
		let userPersistentData = NSUserDefaults.standardUserDefaults()
		let addedIdOpt = userPersistentData.arrayForKey(persistentKey) as? [Int]
		var addedId = [Int]()
		if addedIdOpt != nil {
			for saveId in addedIdOpt! {
				if (idExist(saveId)) {
					addedId.append(saveId)
				}
			}
		}
		userPersistentData.setObject(addedId, forKey: persistentKey)
		userPersistentData.synchronize()
	}
	
	// MARK: - Private methods
	/**
	Add a scaleTeam in persistent data
	
	- Parameters :
		- idScaleTeam : Int id of an scaleTeam
		- dateScaleTeam : NSDate date of an scaleTeam
	*/
	private func addPersitentId(idScaleTeam: Int){
		/// Singleton of the user persistent data
		let userPersistentData = NSUserDefaults.standardUserDefaults()
		let addedIdOpt = userPersistentData.arrayForKey(persistentKey) as? [Int]
		var addedId = [Int]()
		if addedIdOpt != nil {
			addedId = addedIdOpt!
		}
		
		addedId.append(idScaleTeam)
		userPersistentData.setObject(addedId, forKey: persistentKey)
		userPersistentData.synchronize()
	}
	
	/**
	Return true if id of a scale team exist.
	Please use `cleanOldScaleTeamPersistentData()` before.
	
	- Parameters:
		- idScaleTeam: Int id of an scaleTeam
		- dateScaleTeam: NSDate date of an scaleTeam
	- Returns: True if id already exist
	*/
	private func persitentIdExist(idScaleTeam: Int) -> Bool {
		/// Singleton of the user persistent data
		let userPersistentData = NSUserDefaults.standardUserDefaults()
		let addedIdOpt = userPersistentData.arrayForKey(persistentKey) as? [Int]
		if addedIdOpt != nil {
			for idOpt in addedIdOpt! {
				if idOpt == idScaleTeam {
					return true
				}
			}
		}
		return false
	}
}