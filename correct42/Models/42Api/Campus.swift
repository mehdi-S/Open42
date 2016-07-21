//
//  Campus.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a campus.
class Campus: SuperModel{

	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Number of user in the campus
	lazy var usersCount:Int = {
		return (self.jsonData["users_count"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// Time Zone value
	lazy var timeZone:String = {
		return (self.jsonData["time_zone"].stringValue)
	}()
	
	// MARK: - Single Typed
	/// Primary language of a campus
	lazy var language:Language = {
		return (Language(jsonFetch: self.jsonData["language"]))
	}()
}
