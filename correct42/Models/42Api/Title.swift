//
//  Title.swift
//  correct42
//
//  Created by larry on 26/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a title.
class Title: SuperModel{
	
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
}
