//
//  ViewController.swift
//  correct42
//
//  Created by larry on 16/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate, SearchManagerDelegation{

	// MARK: - Singletons
	/// Singleton of `ApiRequester`
	let apiRequester = ApiRequester.Shared()
	
	/// Singleton of the `UserManager`
	let userManager = UserManager.Shared()
	
	/// Singleton of the `SearchManager`
	let searchManager = SearchManager.Shared()
	
	// MARK: - IBOutlets
	/// Display progression of loading
	@IBOutlet weak var progressBarLogin: UIProgressView!
	
	/// Display an indicator of activity
	@IBOutlet weak var LoginLoading: UIActivityIndicatorView!
	
	/// Information label to know where we are in loading.
	@IBOutlet weak var loadingInformationsLabel: UILabel!
	
	/// Button who launch connection to 42 API. @IBOutlet exist just for hidding it.
	@IBOutlet weak var button42Login: UIButton!
	
	
	// MARK: - IBActions
	/**
	Ask to the APIResquester singleton to connect the user to the 42 school API.
	
	If success set the `isConnected` Bool to True
	
	else print an error message in the console.
	*/
	@IBAction func connect42(sender: UIButton) {
		LoginLoading.startAnimating()
		apiRequester.connectApi(self, delegateSafari: self, success: { () in
			self.isConnected = true
		}) { (error) in
			print("Error code : \(error.code)")
		}
	}
	
	// MARK: - Proprieties
	/// Boolean who determine if the api connection is successfull
	var isConnected = false
	
	// MARK: - Default Styles definitions
	/// Determine the color of the Status Bar at `.LightContent`
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - View life cycle
	/**
	Delegate the search manager and hide the `progressBarLogin`.
	*/
	override func viewDidLoad() {
		searchManager.delegate = self
		progressBarLogin.hidden = true
	}
	
	/**
	Set the `progressBarLogin` progress to 0,
	check connect() (work at SafariView dissmiss)
	and set loadingInformationsLabel to ""
	*/
	override func viewDidAppear(animated: Bool) {
		progressBarLogin.progress = 0.0
		loadingInformationsLabel.text = ""
		connect()
	}
	
	// MARK: - SafariView delegate
	/**
	Stop the loginLoading.
	*/
	func safariViewControllerDidFinish(controller: SFSafariViewController) {
		self.LoginLoading.stopAnimating()
	}
	
	// MARK: - Search Manager delegation
	/**
	Give to the `progressBarLogin` his progression.
	*/
	func searchManager(percentOfCompletion percent: Int) {
		let percentFloat = Float(percent)/100
		progressBarLogin.progress = percentFloat
	}
	
	// MARK: - Private Methods
	/**
	Connect action
	
	if `isConnect` is True:
	1. `button42Login` hidden
	2. Put isConnected to false
	3. Fetch user
	
	if `isConnect` is False:
	1. `progressBarLogin` hidden
	2. Stop animating LoginLoading
	*/
	private func connect(){
		dispatch_async(dispatch_get_main_queue()){
			if (self.isConnected){
				self.button42Login.hidden = true
				self.isConnected = false
				self.fetchUser()
			} else {
				self.progressBarLogin.hidden = true
				self.LoginLoading.stopAnimating()
			}
		}
	}
	
	/**
	start `LoginLoading` animation, set `loadingInformationsLabel` text and
	Fetch profil of the token owner put result in both `userManager.loginUser`,
	`userManager.currentUser`, next execute `fetchListUser` function.
	*/
	private func fetchUser(){
		self.LoginLoading.startAnimating()
		self.loadingInformationsLabel.text = "Loading profile..."
		self.userManager.fetchMyProfil({ (user) in
			self.userManager.loginUser = user
			self.userManager.currentUser = user
			self.fetchListUser()
		}) { (error) in
			print(error.domain)
		}
	}
	
	/**
	Set `progressBarLogin` hidden to false, set `loadingInformationsLabel` text and
	if the users list file doen't exist, fetching the entire list of user admit to 42 in file and `searchManager.listSearchUser` else retrive users from the file and perform segue `connectSegue` if all's good.
	
	At the end: stop animate `LoginLoading`, display `button42Login` and hide `progressBarLogin`.
	*/
	private func fetchListUser() { // ~2 min 30.
		self.progressBarLogin.hidden = false
		self.loadingInformationsLabel.text = "Loading users list for research more faster than ever...\n(Only happens once a year)"
		if !searchManager.fileAlreadyExist() {
			searchManager.fetchAllUsersFromAPI{ (success, error) in
				if (success){
					self.performSegueWithIdentifier("connectSegue", sender: self)
				} else {
					showAlertWithTitle("Loading users list", message: "A problem occured.", view: self)
				}
				self.LoginLoading.stopAnimating()
				self.button42Login.hidden = false
				self.progressBarLogin.hidden = true
			}
		} else {
			progressBarLogin.progress = 1.0
			searchManager.fetchUsersFromFile({ (success, error) in
				if (success){
					self.performSegueWithIdentifier("connectSegue", sender: self)
				} else {
					showAlertWithTitle("Loading users list", message: "A problem occured.", view: self)
				}
				self.LoginLoading.stopAnimating()
				self.button42Login.hidden = false
				self.progressBarLogin.hidden = true
			})
		}
	}
}

