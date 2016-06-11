//
//  ScaleTeamsRouter.swift
//  correct42
//
//  Created by larry on 15/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Alamofire

/// Scale Team informations of Api 42 route based on protocol `ApiRouter`
enum ScaleTeamsRouter: ApiRouter {
	
	// MARK: - Cases
	/**
	This case read all the scale team of the owner of the token
	*/
	case Me
	
	// MARK: - APIRouter protocols
	/**
	- .Me = .GET
	*/
	var method: Alamofire.Method {
		switch self {
		case .Me:
			return .GET
		}
	}
	
	/**
	- .Me = "/me/scale_teams"
	*/
	var path: String {
		switch self {
		case .Me:
			return "/me/scale_teams"
		}
	}
	
	/**
	- default = ""
	*/
	var parameters:String{
		switch self {
		default:
			return ""
		}
	}
	
	/**
	- default = "https://api.intra.42.fr/v2"
	*/
	var baseUrl:String{
		switch self {
		default:
			return "https://api.intra.42.fr/v2"
		}
	}
}
