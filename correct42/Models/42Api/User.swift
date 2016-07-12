//
//  user.swift
//  correct42
//
//  Created by larry on 20/04/2016.
//  Copyright © 2016 42. All rights reserved.
//
import SwiftyJSON

// Model who define what's an user.
class User : SuperModel {
	
	// MARK: - Int
	/// Unique Id.
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Number of corrections points.
	lazy var correctionPoint:Int = {
		return (self.jsonData["correction_point"].intValue)
	}()
	
	/// Number of wallets.
	lazy var wallet:Int = {
		return (self.jsonData["wallet"].intValue)
	}()
	
	// MARK: - String
	/// Email.
	lazy var email:String = {
		return (self.jsonData["email"].stringValue)
	}()
	
	/// Login.
	lazy var login:String = {
		return (self.jsonData["login"].stringValue)
	}()
	
	/// Url.
	lazy var url:String = {
		return (self.jsonData["url"].stringValue)
	}()
	
	/// Phone number.
	lazy var phone:String = {
		return (self.jsonData["phone"].stringValue)
	}()
	
	/// Full name.
	lazy var displayName:String = {
		return (self.jsonData["displayname"].stringValue)
	}()
	
	/// Surname 
	var surname:String {
		get{
			let surname = displayName.componentsSeparatedByString(" ")[0]
			if surname != "" {
				return (surname)
			}
			return ""
		}
	}
	
	/// Url of the profil image.
	lazy var imageUrl:String = {
		return (self.jsonData["image_url"].stringValue)
	}()
	
	/// Pool month.
	lazy var poolMonth:String = {
		return (self.jsonData["pool_month"].stringValue)
	}()
	
	/// Pool year.
	lazy var poolYear:String = {
		return (self.jsonData["pool_year"].stringValue)
	}()
	
	/// Logued in location in 42 School.
	lazy var location:String = {
		return (self.jsonData["location"].stringValue)
	}()
	
	// MARK: - Bool
	/// True if the user is in the staff.
	lazy var staff:Bool = {
		return (self.jsonData["staff?"].boolValue)
	}()
	
	// MARK: - Array
	/// Array of `Cursus`.
	lazy var cursus:[Cursus] = {
		var cursusGet = [Cursus]()
		for cursus in self.jsonData["cursus_users"].arrayValue {
			cursusGet.append(Cursus(jsonFetch: cursus))
		}
		return (cursusGet)
	}()
	
	/// Array of `Achievement`.
	lazy var achievements:[Achievement] = {
		var achievementGet = [Achievement]()
		for achievement in self.jsonData["achievements"].arrayValue{
			achievementGet.append(Achievement(jsonFetch: achievement))
		}
		return (achievementGet)
	}()
	
	/// Array of `Title`.
	lazy var titles:[Title] = {
		var titlesGet = [Title]()
		for title in self.jsonData["titles"].arrayValue{
			titlesGet.append(Title(jsonFetch: title))
		}
		return (titlesGet)
	}()
	
	/// Array of patroned `User`.
	lazy var patroned:[User] = {
		var userGet = [User]()
		for user in self.jsonData["patroned"].arrayValue{
			userGet.append(User(jsonFetch: user))
		}
		return (userGet)
	}()
	
	/// Array of patroning `User`.
	lazy var patroning:[User] = {
		var userGet = [User]()
		for user in self.jsonData["patroning"].arrayValue{
			userGet.append(User(jsonFetch: user))
		}
		return (userGet)
	}()
	
	/// Array of `Campus` where the user be registred.
	lazy var campus:[Campus] = {
		var campusGet = [Campus]()
		for campus in self.jsonData["campus"].arrayValue{
			campusGet.append(Campus(jsonFetch: campus))
		}
		return (campusGet)
	}()
	
	/// Array of `Projects` where the user be registred.
	lazy var projects:[Project] = {
		var projectGet = [Project]()
		for project in self.jsonData["projects_users"].arrayValue{
			projectGet.append(Project(jsonFetch: project))
		}
		return (projectGet)
	}()
	
	// MARK: - Initialisers
	/// Init an user with his login and id.
	init(login:String, id:Int){
		super.init(jsonFetch: "")
		self.login = login
		self.id = id
	}
	
	/// Init an user with data fetch from the 42 School's REST API.
	required init(jsonFetch:JSON){
		super.init(jsonFetch: jsonFetch)
	}
}