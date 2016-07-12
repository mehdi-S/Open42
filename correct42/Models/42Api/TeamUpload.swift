//
//  TeamUpload.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's an upload from a team.
class TeamUpload : SuperModel {
	
	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Id of the upload
	lazy var uploadId:Int = {
		return (self.jsonData["upload_id"].intValue)
	}()
	
	/// Final mark value
	lazy var finalMark:Int = {
		return (self.jsonData["final_mark"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// Coment on the upload
	lazy var coment:String = {
		return (self.jsonData["comment"].stringValue)
	}()
	
	/// Date of creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()

	// MARK: - Single Typed
	/// Upload model
	lazy var upload:Upload = {
		return (Upload(jsonFetch: self.jsonData["upload"]))
	}()
}
