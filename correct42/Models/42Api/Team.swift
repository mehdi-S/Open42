//
//  Team.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

/// Model who define what's a team.
class Team : SuperModel{
	
	// MARK: - Int
	/// Id value
	lazy var id:Int = {
		return (self.jsonData["id"].intValue)
	}()
	
	/// Final mark
	lazy var finalMark:Int = {
		return (self.jsonData["final_mark"].intValue)
	}()
	
	/// Id of the team link on project
	lazy var projectId:Int = {
		return (self.jsonData["project_id"].intValue)
	}()
	
	// MARK: - String
	/// Name value
	lazy var name:String = {
		return (self.jsonData["name"].stringValue)
	}()
	
	/// Url value
	lazy var url:String = {
		return (self.jsonData["url"].stringValue)
	}()
	
	/// Date of creation
	lazy var createdAt:String = {
		return (self.jsonData["created_at"].stringValue)
	}()
	
	/// Date of the last update
	lazy var updatedAt:String = {
		return (self.jsonData["updated_at"].stringValue)
	}()
	
	/// Git repository Url
	lazy var repoUrl:String = {
		return (self.jsonData["repo_url"].stringValue)
	}()
	
	/// Git repository Uuid
	lazy var repoUuid:String = {
		return (self.jsonData["repo_uuid"].stringValue)
	}()
	
	/// Date of locking the team users
	lazy var lockedAt:String = {
		return (self.jsonData["locked_at"].stringValue)
	}()
	
	/// Date of setting as finish the project
	lazy var closedAt:String = {
		return (self.jsonData["closed_at"].stringValue)
	}()

	// MARK: - Bool
	/// True if team is locked
	lazy var locked:Bool = {
		return (self.jsonData["staff?"].boolValue)
	}()
	
	/// True if the project is finish
	lazy var closed:Bool = {
		return (self.jsonData["staff?"].boolValue)
	}()
	
	// MARK: - Array
	/// List of users in the team
	lazy var users:[User] = {
		var userGet = [User]()
		for user in self.jsonData["users"].arrayValue {
			userGet.append(User(jsonFetch: user))
		}
		return (userGet)
	}()
	
	/// List of correction for the team
	lazy var scaleTeams:[ScaleTeam] = {
		var scaleTeamsGet = [ScaleTeam]()
		for scaleTeam in self.jsonData["scale_teams"].arrayValue {
			scaleTeamsGet.append(ScaleTeam(jsonFetch: scaleTeam))
		}
		return (scaleTeamsGet)
	}()
	
	lazy var teamsUploads:[TeamUpload] = {
		var teamsUploadsGet = [TeamUpload]()
		for teamUpload in self.jsonData["teams_uploads"].arrayValue {
			teamsUploadsGet.append(TeamUpload(jsonFetch: teamUpload))
		}
		return (teamsUploadsGet)
	}()
}
