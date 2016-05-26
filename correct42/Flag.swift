//
//  Flag.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a flag.
class Flag : SuperModel{
	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// Icon ame
	lazy var icon:String = {
		return (self.jsonData["icon"].stringValue)
	}()
	
	/// Date of creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()
	
	/// Date of last update
	lazy var updatedAt:String = {
		return (self.jsonData["updated_at"].stringValue)
	}()

	// MARK: - Bool
	/// True if he's positive
	lazy var positive:Bool = {
		return (self.jsonData["positive"].boolValue)
	}()
}
