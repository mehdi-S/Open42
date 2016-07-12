
//
//  achievement.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's an achievement.
class Achievement: SuperModel{
	
	// MARK: - Int
	/// Unique Id
	lazy var id:Int  = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Number of occurence need.
	lazy var nbrOfSuccess:Int = {
		return (self.jsonData["nbr_of_success"].intValue)
	}()
	
	// MARK: - String
	/// Name
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// What you need to do to get it.
	lazy var description:String = {
		return (self.jsonData["description"].stringValue)
	}()
	
	/// Tier value
	lazy var tier:String = {
		return (self.jsonData["tier"].stringValue)
	}()
	
	/// Can be bronze, silver or gold but please check this fact before
	lazy var kind:String = {
		return (self.jsonData["kind"].stringValue)
	}()
	
	/// Url Image
	lazy var image:String = {
		return (self.jsonData["image"].stringValue)
	}()
	
	lazy var usersUrl:String = {
		return (self.jsonData["users_url"].stringValue)
	}()
	
	// MARK: - Bool
	lazy var visible:Bool = {
		return (self.jsonData["visible"].boolValue)
	}()
	
	// MARK: - Array
	/// Achiements needed to unlock current achievement
	lazy var achievements:[Achievement] = {
		var achievementsGet = [Achievement]()
		for achievement in self.jsonData["achievements"].arrayValue {
			achievementsGet.append(Achievement(jsonFetch: achievement))
		}
		return (achievementsGet)
	}()
	
	// MARK: - Single Typed
	/// Parent achievement
	lazy var parent:Achievement = {
		return (Achievement(jsonFetch: self.jsonData["parent"]))
	}()
	
	/// Title value
	lazy var title:Title = {
		return (Title(jsonFetch: self.jsonData["title"]))
	}()

}
