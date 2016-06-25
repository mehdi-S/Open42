//
//  ApiGeneralError.swift
//  Open42
//
//  Created by larry on 05/06/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit
import Foundation

/// Permit to centralize `apiRequester` errors
class ApiGeneral {
	// MARK: - Singletons
	/// Singleton of `ApiRequester`
	let apiRequester = ApiRequester.Shared()
	
	/// View who display the error
	let view:UIViewController!
	
	/// Title of the alert
	let title = "Open 42"
	
	/// Init with the displayer
	init(myView:UIViewController){
		view = myView
	}
	
	/**
	 Check if the error is known
	- Parameter nsError: NSError with a status code
	- Parameter animate: if change view on error, use for login page auto-login.
	*/
	func check(nsError:NSError, animate:Bool){
		switch nsError.code {
		case 400:
			print("The request is malformed")
			break
		case 401:
			showAlertWithTitle(title, message: "Token have expired and we can't reconnect.", view: view)
			if (animate){
				self.goToLogin()
			}
			break
		case 403:
			print("Forbidden Request")
			break
		case 404:
			showAlertWithTitle(title, message: "The requested endpoint seems to be down.", view: view)
			break
		case 422:
			print("Unprocessable entity")
			break
		case 500:
			showAlertWithTitle(title, message: "We have some problem with the api server, please try again later.", view: view)
			break
		default:
			showAlertWithTitle(title, message: "Please check your internet connection and try again.", view: view)
			break
		}
	}
	
	/**
	Perform a segue to the login if an access are forbidden
	*/
	private func goToLogin(){
		let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
		view.presentViewController(vc, animated: true, completion: nil)
	}
	
	
}