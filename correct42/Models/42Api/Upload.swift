//
//  Upload.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's an upload.
class Upload : SuperModel {
	
	// MARK: - Int
	/// Id Value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Evaluation id value
	lazy var evaluationId:Int = {
		return (self.jsonData["evaluation_id"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// Desciption value
	lazy var description:String = {
		return (self.jsonData["description"].stringValue)
	}()
	
	/// Date of the creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()
	
	/// Date of the last update
	lazy var updatedAt:String = {
		return (self.jsonData["updated_at"].stringValue)
	}()

}
