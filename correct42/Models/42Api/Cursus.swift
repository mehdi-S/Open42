//
//  Cursus.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a cursus
class Cursus : SuperModel {
	
	// MARK: - Int
	/// Id value
	lazy var id:Int  = {
		return (self.jsonData["cursus"]["id"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["cursus"]["name"].stringValue)
	}()
	
	/// Date of creation
	lazy var createAt:String = {
		return (self.jsonData["cursus"]["create_at"].stringValue)
	}()
	
	/// Date of last update
	lazy var updatedAt:String = {
		return (self.jsonData["cursus"]["update_at"].stringValue)
	}()
	
	/// Name Slug
	lazy var slug:String = {
		return (self.jsonData["cursus"]["slug"].stringValue)
	}()
	
	/// Date of the end
	lazy var endAt:String = {
		return (self.jsonData["end_at"].stringValue)
	}()
	
	/// Level of current `User`
	lazy var level:String = {
		return (self.jsonData["level"].stringValue)
	}()
	
	/// Level of current `User`
	lazy var grade:String = {
		return (self.jsonData["grade"].stringValue)
	}()
	
	// MARK: - Array
	/**
	list of skills
	Can be fill by:
	- All skills in a user's Cursus
	- All skills in a cursus
	*/
	lazy var skills:[Skill] = {
		var skillsGet = [Skill]()
		for skill in self.jsonData["skills"].arrayValue{
			skillsGet.append(Skill(jsonFetch: skill))
		}
		return (skillsGet)
	}()
}
