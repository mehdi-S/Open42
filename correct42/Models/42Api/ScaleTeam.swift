//
//  ScaleTeam.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a scale of a team.
import Foundation

class ScaleTeam : SuperModel{
	
	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Scale id calue
	lazy var scaleId:Int = {
		return (self.jsonData["scale_id"].intValue)
	}()
	
	lazy var team:Int = {
		return (self.jsonData["team"].intValue)
	}()
	
	/// Feedback's mark on a correction
	lazy var feedBackRating:Int = {
		return (self.jsonData["feedBack_rating"].intValue)
	}()
	
	/// Final Mark
	lazy var finalMark:Int = {
		return (self.jsonData["final_mark"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	lazy var comment:String = {
		return (self.jsonData["comment"].stringValue)
	}()
	
	/// Date of creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()
	
	/// Date of the last update
	lazy var updatedAt:String = {
		return (self.jsonData["updated_at"].stringValue)
	}()
	
	lazy var feedback:String = {
		return (self.jsonData["feedback"].stringValue)
	}()
	
	/// Date of the work beginning
	lazy var beginAt:NSDate = {
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
		dateFormatter.dateFormat = "yyyy-LL-dd'T'HH:mm:ss'.'SSSz"
		if let startDate = dateFormatter.dateFromString(self.jsonData["begin_at"].stringValue){
			return (startDate)
		}
		return (NSDate())
	}()
	
	var beginAtFormated:String {
		get {
			let dateFormat = NSDateFormatter()
			dateFormat.locale = NSLocale(localeIdentifier: "fr_FR")
			dateFormat.dateFormat = "'on' dd/LL/yyyy 'at' HH:mm"
			return (dateFormat.stringFromDate(self.beginAt))
		}
	}
	
	// MARK: - Single Typed
	/// Flag description (usually an icon)
	lazy var flag:Flag = {
		return (Flag(jsonFetch: self.jsonData["flag"]))
	}()
	
	/// List of corrected users
	lazy var correcteds:[User] = {
		var userGet = [User]()
		for user in self.jsonData["correcteds"].arrayValue {
			userGet.append(User(jsonFetch: user))
		}
		return (userGet)
	}()
	
	/// `User` object of the corrector
	lazy var corrector:User? = {
		return (User(jsonFetch: self.jsonData["corrector"]))
	}()
	
	/// `Scale` of the project
	lazy var scale:Scale = {
		return (Scale(jsonFetch: self.jsonData["scale"]))
	}()

}
