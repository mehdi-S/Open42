//
//  SearchUserContainerViewController.swift
//  correct42
//
//  Created by larry on 02/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
Show an user profil. he's call Search because this is the first needed of 
a container profil. Now, the scaleTeamViewController perform segue to it too.
*/
class SearchUserContainerViewController: UIViewController {

	// MARK: - Singletons
	/// Singleton of `UserManger`
	let userManager = UserManager.Shared()
	let friendsManager = FriendsManager.Shared()
	
	// MARK: - IBOutlets
	@IBOutlet weak var addFriendButton: UIBarButtonItem!
	
	// MARK: - IBActions
	@IBAction func addFriend(sender: UIBarButtonItem) {
		if let currentUser = userManager.currentUser, let loginUser = userManager.loginUser{
			FriendsManager.Shared().add(currentUser, forThe:loginUser){
				(errorOpt) in
				if let error = errorOpt {
					showAlertWithTitle("Friends", message: error.userInfo.first?.1 as! String, view: self)
				} else {
					self.addFriendButton.image = nil
					showAlertWithTitle("Friends", message: "\(currentUser.login) has been added to your friend list", view: self)
				}
			}
		} else {
			showAlertWithTitle("Friends", message: "Sorry, an internal problem occured. Please close the app and retry.", view: self)
		}
	}
	
	// MARK: - View life cycle
	/// Set `self.title` to Default value
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.title = "Unknown"
	}
	
	/// Fill `self.title` with the login of the `self.userManager.currentUser`
	override func viewWillAppear(animated: Bool) {
		if let currentUser = self.userManager.currentUser {
			self.title = currentUser.login
			if friendsManager.exist(currentUser) {
				addFriendButton.image = nil
			}
		}
	}
}
