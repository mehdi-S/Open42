//
//  Scale.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a scale.
class Scale: SuperModel{
	
	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Id of the evaluation
	lazy var evaluationId:Int = {
		return (self.jsonData["evaluation_id"].intValue)
	}()
	
	/// Number of corrections
	lazy var correctionNumber:Int = {
		return (self.jsonData["correction_number"].intValue)
	}()
	
	/// Duration of a correction
	lazy var duration:Int = {
		return (self.jsonData["duration"].intValue)
	}()
	
	// MARK: - String
	/// Coment on top
	lazy var comment:String = {
		return (self.jsonData["comment"].stringValue)
	}()
	
	/// Introductions value
	lazy var introductionMd:String = {
		return (self.jsonData["introduction_md"].stringValue)
	}()
	
	/// Disclamer value
	lazy var disclamerMd:String = {
		return (self.jsonData["disclamer_md"].stringValue)
	}()
	
	/// Guideline value
	lazy var guidelineMd:String = {
		return (self.jsonData["guideline_md"].stringValue)
	}()
	
	/// Date of the creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()
	
	/// Name value
	lazy var name:String = {
		if let name = self.jsonData["name"].string{
			return name.stringByReplacingOccurrencesOfString("_", withString: " ").stringByReplacingOccurrencesOfString("-copy", withString: "")
		}
		return ("Unknow Project")
	}()
	
	// MARK: - Bool
	/// True if it the primary
	lazy var isPrimary:Bool = {
		return (self.jsonData["is_primary"].boolValue)
	}()
	
	/// True if the subscrition is manual
	lazy var manualSubscription:Bool = {
		return (self.jsonData["staff?"].boolValue)
	}()
	
	// MARK: - Single Typed
	/// Define the language of the scale project
	lazy var language:Language = {
		return (Language(jsonFetch: self.jsonData["language"]))
	}()
}