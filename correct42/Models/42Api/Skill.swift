//
//  Skill.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a skill.
class Skill: SuperModel {
	
	// MARK: - Int
	/// Id value
	lazy var id:Int  = {
		return (self.jsonData["id"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	// MARK: - Float
	/// Level of the skill
	lazy var level:Float = {
		return (self.jsonData["level"].floatValue)
	}()
}
