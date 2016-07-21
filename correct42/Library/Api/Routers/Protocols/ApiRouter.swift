//
//  Protocol.swift
//  correct42
//
//  Created by larry on 27/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Alamofire

/**
Protocol for Api Routers. Use to get the inherit ressources route.
*/
public protocol ApiRouter {
	/**
	Method of request, can be:
	
	.OPTIONS
	.GET
	.HEAD
	.POST
	.PUT
	.PATCH
	.DELETE
	.TRACE
	.CONNECT
	
	*/
	var method:Alamofire.Method{get}
	
	/**
	get the end of url path in the requested case
	*/
	var path:String{get}
	
	/**
	get the parameter of url path in the requested case
	*/
	var parameters:[String:AnyObject]?{get}
	
	/**
	get the base of url in the requested case
	*/
	var baseUrl:String{get}
}