//
//  File.swift
//  Peligourmet
//
//  Created by larry on 21/06/2016.
//  Copyright © 2016 Péligourmet. All rights reserved.
//

import UIKit
import p2_OAuth2
import SwiftyJSON

class DuoQuadraLoader : DataLoader {
	/**
	OAuth2 Mod.
	Can be Any type of oAuth2.
	*/
	var oauth2:AnyObject?
	
	/**
	Domain identifier
	*/
	var domain:String = "42 Api"
	
	/**
	Authorize session to fetching request of Peligourmet Api.
	*/
	func authorize(viewControllerOpt: UIViewController?, callback: (wasFailure: Bool, error: ErrorType?) -> Void) {
		if let oauth = oauth2 as? OAuth2CodeGrant {
			if let viewController = viewControllerOpt {
				oauth.authConfig.authorizeEmbedded = true
				oauth.authConfig.authorizeContext = viewController
			}
			oauth.afterAuthorizeOrFailure = callback
			oauth.authorize()
		}
	}
	
	/**
	Init the loader with an tuple string username and password.
	*/
	init(){
		oauth2 = OAuth2CodeGrant.init(settings: [
			"client_id": "<#UID#>",
			"client_secret": "<#Secret#>",
			"authorize_uri":"https://api.intra.42.fr/oauth/authorize",
			"token_uri": "https://api.intra.42.fr/oauth/token",
			"redirect_uris":["correct42://oauth-callback/intra"],
			"keychain": true
		])
	}
	
	/**
	Refresh the access token of a `DataLoader`
	- Parameters:
	- oAuth2Loader: `DataLoader` protocol of an RestFull Api
	- oAuth2Module: `OAuth2PasswordGrant` instance.
	- doOptRequest: Do a something after refresh token. Can be nil.
	*/
	func refreshToken(callBack:((JSON?,NSError?)->Void)?)
	{
		if let oAuth2CodeGrant = oauth2 as? OAuth2CodeGrant {
			oAuth2CodeGrant.doRefreshToken(callback: { (successParamsOpt, errorOpt) in
				if let successParams = successParamsOpt {
					callBack!(JSON("\(successParams)"),nil)
				} else {
					if let callbackNOpt = callBack {
						if let error = errorOpt {
							callbackNOpt(nil, NSError(domain: self.domain, code: -1, userInfo: ["error":"\(error)"]))
						} else {
							callbackNOpt(nil, NSError(domain: self.domain, code: -1, userInfo: ["error":"Unknow Error"]))
						}
					}
				}
			})
		}
	}
	
	/**
	Return authorization Header in a new dictionnary from protocol. Check if token is expired and if it is refresh and try again with the callback.
	- Parameters:
	- router: Router of an request
	- oAuth2Protocol: Protocol `DataLoader` to get token access, to
	- oAuthModule:
	- Returns: dictionnary headers of `oAuthProtocol` for `OAuth2PasswordGrant` type.
	*/
	func getHeadersFromProtocolAuthorizedOrRefreshAndRequest(router:ApiRouter, retry: (()->Void)?) -> [String:String]?{
		if let oAuth2CodeGrant = oauth2 as? OAuth2CodeGrant {
			var hdrs:[String:String]? = [:]
			if isAuthorized(){
				// Add Access token to the request's headers
				if let token = oAuth2CodeGrant.accessToken {
					hdrs!["Authorization"] = "Bearer \(token)"
				}
			} else {
				if let callbackNOpt = retry {
					callbackNOpt()
				}
				return nil
			}
			return hdrs
		}
		print ("No DataLoader implemented in DuoquadraLoader")
		return nil
	}
	
	/**
	Check if the access token has expired.
	*/
	func isAuthorized() -> Bool {
		if let oAuth2CodeGrant = oauth2 as? OAuth2CodeGrant {
			if let _ = oAuth2CodeGrant.accessToken {
				return oAuth2CodeGrant.hasUnexpiredAccessToken()
			}
			
		}
		return false
	}
}