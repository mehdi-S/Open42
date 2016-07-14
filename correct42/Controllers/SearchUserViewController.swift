//
//  SearchUserViewController.swift
//  correct42
//
//  Created by larry on 02/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
Display the list of all 42 School students in a tableView `usersTable`
*/
class SearchUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	// MARK: - IBOutlets
	/// Table view of each `users`
	@IBOutlet weak var usersTable: UITableView!
	
	/// Search Bar to filter `users`
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: - Singletons
	/// Singleton of `UserManager`
	let userManager = UserManager.Shared()
	/// Singleton of `SearchManager`
	let searchManager = SearchManager.Shared()
	
	// MARK: - Proprieties
	/// Name of the custom cell call by the `usersTable`
	let cellName = "searchUserCell"
	
	/// Lazy array of all users admit to School 42, sort in alphabetical order
	lazy var users:[(String,[User])] = {
		return (self.searchManager.userListGroupByFirstLetter)
	}()

	/// Bool to keep loading two users in same time.
	var requestInProgress = false
	
	//MARK: - View methods
	/**
	On View did load :
	1. Register Custom cells, fill delegate and dataSource `usersTable` by `SearchUserViewController` and reload `usersTable`.
	2. Set Color and backgroundColor of the index section table
	3. Delegate the searchBar by `SearchUserViewController`
	*/
    override func viewDidLoad() {
        super.viewDidLoad()
		let nib = UINib(nibName: cellName, bundle: nil)
		usersTable.registerNib(nib, forCellReuseIdentifier: cellName)
		usersTable.delegate = self
		usersTable.dataSource = self
		usersTable.reloadData()
		
		usersTable.sectionIndexColor = UIColor.whiteColor()
		usersTable.sectionIndexBackgroundColor = UIColor.clearColor()
		
		searchBar.delegate = self
    }
	
	// MARK: - SearchBar delegation
	/// If the text in `searchBar` change, this methods call `searchValueOnAPI` private function
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		filterUsersWithLoginValue(searchText.lowercaseString)
	}
	
	/**
	Display an header with the string key 
	in collectionArray `users`
	*/
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let titleForHeaderInSection = users[section].0
		return (titleForHeaderInSection.uppercaseString)
	}
	
	// MARK: - TableView delegation
	/// Count `users` for the `usersTable` numberOfRowsInSection.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRowsInSection = users[section].1.count
		return (numberOfRowsInSection)
	}
	
	/// Give to `usersTable` the number of section (first letter login)
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		let sectionCount = users.count
		return (sectionCount)
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 48
	}
	
	func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		var arrayTitle = [String]()
		for section in users{
			arrayTitle.append(section.0 + " ")
		}
		if arrayTitle.count > 5 {
			return arrayTitle
		}
		return nil
	}
	
	/**
	Fetch the selected user and perform a request (if `requestInProgress` == false)
	*/
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let userObject = users[indexPath.section].1[indexPath.row]
		if (!requestInProgress){
			requestInProgress = true
			userManager.fetchUserById(userObject.id, success: { (user) in
					self.requestInProgress = false
					self.userManager.searchUser = user
					self.performSegueWithIdentifier("goToUserSearch", sender: self)
				}) { (error) in
					self.requestInProgress = false
					ApiGeneral(myView: self).check(error, animate: true)
			}
		}
	}
	
	/**
	Create a `SearchUserTableViewCell` and fill it.
	- Returns: An `SearchUserTableViewCell` filled.
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let userObject = users[indexPath.section].1[indexPath.row]
		let userListCellPrototype:SearchUserTableViewCell? = {
			let userSearchCell = self.usersTable.dequeueReusableCellWithIdentifier(self.cellName)
			if userSearchCell is SearchUserTableViewCell{
				return (userSearchCell as! SearchUserTableViewCell)
			}
			return (nil)
		}()
		userListCellPrototype!.loginUser.text = userObject.login
		userListCellPrototype!.displayName.text = "\(userObject.lastName.capitalizedString) \(userObject.firstName.capitalizedString)"
		return (userListCellPrototype!)
	}
	
	// MARK: - Segue methods
	/// Set `userManager.searchUser` in `userManager.currentUser` to fill the user container view
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.destinationViewController is SearchUserContainerViewController{
			if let userSearch = self.userManager.searchUser{
				self.userManager.currentUser = userSearch
			}
		}
	}
	
	// MARK: - Private methods
	/**
	1. Remove all data from user and filter with `login` parameter in `searchManager.listSearchUser`.
	2. Reload data in `usersTable`.
	
	if `login` parameter is empty, display all users
	
	- Parameter login: Login research in `searchManager.listSearchUser`
	*/
	private func filterUsersWithLoginValue(login:String){
		if (login != ""){
			self.users.removeAll()
			self.users = searchManager.groupFromResearch(login)
			self.usersTable.reloadData()
		} else {
			self.users.removeAll()
			self.users = searchManager.userListGroupByFirstLetter
			self.usersTable.reloadData()
		}
	}
}
