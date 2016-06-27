//
//  project.swift
//  correct42
//
//  Created by larry on 20/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

// Model who define what's a Project
class Project : SuperModel{
	
	// MARK: - Int
	/// Dd of a project.
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Mark give at the end of correction.
	lazy var finalMark:Int = {
		return (self.jsonData["final_mark"].intValue)
	}()
	
	/// Number of time the user retry the project.
	lazy var occurence:Int = {
		return (self.jsonData["occurence"].intValue)
	}()
	
	/// Id of the project link user.
	lazy var projectUserId:Int = {
		return (self.jsonData["project_user_id"].intValue)
	}()
	
	// MARK: - String
	/// Name of the project.
	lazy var name:String = {
		return (self.jsonData["project"]["name"].stringValue)
	}()
	
	/// Register Date.
	lazy var registeredAt:String = {
		return (self.jsonData["registred_at"].stringValue)
	}()
	
	/// Slug Name (Full name example: "Piscine-Cpp-D00_Date").
	lazy var slug:String = {
		return (self.jsonData["project"]["slug"].stringValue)
	}()
	
	/// Retriable Date.
	lazy var retriableAt:String = {
		return (self.jsonData["retriable_at"].stringValue)
	}()
	
	// MARK: - Array
	/// Id of each try teams.
	lazy var teamsIds:[Int] = {
		var teamsIdsGet = [Int]()
		for teamId in self.jsonData["teams_id"].arrayValue{
			teamsIdsGet.append(teamId.intValue)
		}
		return (teamsIdsGet)
	}()
	
	// MARK: - Single Typed
	// Team object of the active Team.
	lazy var currentTeam:Team = {
		return (Team(jsonFetch: self.jsonData["current_team"]))
	}()
}