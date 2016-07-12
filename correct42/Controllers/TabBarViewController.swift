//
//  TabBarViewController.swift
//  correct42
//
//  Created by larry on 19/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
Implement because we need to switch `UserManager.currentUser` to the switched display user tab.
1. Item : `UserManager.loginUser`
2. Item : `UserManager.searchUser`
3. Item : `UserManager.correctionUser`

Default: `UserManager.loginUser`

viewDidLoad: `UserManager.loginUser`
*/
class TabBarViewController: UITabBarController{

	// MARK: - Singletons
	/// Singleton of `UserManager`
	let userManager = UserManager.Shared()
	
	// MARK: - View life cycle
	/**
	Load `userManager.loginUser` to `userManager.currentUser` for the first tabBar: Profil
	*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		self.userManager.currentUser = self.userManager.loginUser
    }
	
	// MARK: - tabBar delegation
	/// Load the user corresponding to the selected tabBar
	override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
		if let items = tabBar.items {
			switch item {
			case items[0]:
				self.userManager.currentUser = self.userManager.loginUser
				break
			case items[2]:
				self.userManager.currentUser = self.userManager.correctionUser
				break
			case items[3]:
				self.userManager.currentUser = self.userManager.searchUser
				break
			default:
				self.userManager.currentUser = self.userManager.loginUser
				break
			}
		}
	}

}
