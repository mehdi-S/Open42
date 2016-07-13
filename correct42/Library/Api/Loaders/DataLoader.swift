//
//  DataLoader.swift
//  Peligourmet
//
//  Created by larry on 22/06/2016.
//  Copyright © 2016 Péligourmet. All rights reserved.
//

import p2_OAuth2
import UIKit
import SwiftyJSON

/**
Protocol for loader classes.
*/
public protocol DataLoader {
	
	/**
	OAuth2 Mod.
	Can be Any type of oAuth2.
	*/
	var oauth2: AnyObject? { get set }
	
	/**
	Domain identifier
	*/
	var domain: String { get }
	
	/**
	Handled Url deep link
	*/
	func handleRedirectURL(url: NSURL)
	
	/**
	Authorize session to fetching request of Peligourmet Api.
	*/
	func authorize(viewControllerOpt: UIViewController?, callback: (wasFailure: Bool, error: ErrorType?) -> Void)
	
	/**
	Check if access token has expired
	*/
	func isAuthorized() -> Bool
	
	/**
	Refresh token in an instance
	*/
	func refreshToken(callBack:((JSON?,NSError?)->Void)?)
	
	/**
	Return authorization Header in a new dictionnary from protocol.
	Check if token is expired and if it is refresh and try again with the callback.
	*/
	func getHeadersFromProtocolAuthorizedOrRefreshAndRequest(router:ApiRouter, didFail: ((JSON?, NSError?)->Void)?, retry: (()->Void)?) -> [String:String]?
	
	func tokenExpiration()
}


extension DataLoader {
	/**
	Handle a deep link url.
	*/
	func handleRedirectURL(url: NSURL) {
		if let oauth = oauth2 as? OAuth2CodeGrant {
			oauth.handleRedirectURL(url)
		} else {
			print ("No protocol implemented in \(domain) oauth2")
		}
	}
}
