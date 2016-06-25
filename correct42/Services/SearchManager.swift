//
//  SearchManager.swift
//  correct42
//
//  Created by larry on 23/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Foundation

/**
Organize user list file to array of user `list` and allow computed array `userListGroupByFirstLetter` to group users by first letter for the table view headers and index title.
Permit to fetch an user list file from API 42 to update the last one.
*/
class SearchManager {
	// MARK: - Singleton
	/// Static Instance of the Search Manager
	static let instance = SearchManager()
	
	/**
	Give the singleton object of the SearchManager
	
	```
	let listUsers = SearchManager.Shared()
	```
	
	- returns: `static let instance`
	*/
	static func Shared() -> SearchManager {
		return (instance)
	}
	
	// MARK: - Delegations
	var delegate:SearchManagerDelegation?
	
	// MARK: - Proprieties
	/// Array of Users
	lazy var listSearchUser:[User] = [User]()
	
	/// Array of Users sort by array and alpha
	lazy var userListGroupByFirstLetter:[(String, [User])] = {
		let groupArray = self.listSearchUser.groupBy{ (element) -> String in
			if let FirstCharaterLogin = element.login.characters.first{
				return ("\(FirstCharaterLogin)")
			}
			return ("")
		}
		let collectionArray = groupArray.sort({$0.0 < $1.0})
		return (collectionArray)
	}()
		
	
	
	/// Count the current fetched page.
	lazy var currentPage = 0
	
	/// Services to fetch list of all the user
	lazy var apiRequester = ApiRequester.Shared()
	
	/// Constante of the file name
	let nameFile = "usersNameListV1.1.1"
	
	/// Content file of the file at `pathFile`
	var contentFile = ""

	/// Do completion at any time of the execution of a function
	lazy var onCompletionHandler:(Bool,NSError!)->Void = {
		return ({ ( _, _) in
			print("No completion handler implement in SearchManager.");
		})
	}()
	
	/// Fetch directory of the user list file
	lazy var dir:String? = {
		return (NSBundle.mainBundle().pathForResource(self.nameFile, ofType: "txt"))
	}()

	/// Lazy Boolean checking if the users are already fetch
	func fileAlreadyExist() -> Bool {
		if let path = self.dir {
			return NSFileManager().fileExistsAtPath(path)
		}
		else {
			return (false)
		}
	}
	
	// MARK: - List Methods
	/**
	Fetch Users name in `usersNameList.txt`
	
	```
	let searchManager = ScaleTeamsManager.Shared()
	// Start at the first page
	searchManager.fetchUsersOnAPI(0){ (success, error) in
		if (success){
			print(List User : \(self.searchManager.listSearchUser))
		} else {
			showAlertWithTitle("fetch Users On API", message: error.description, view: self)
		}
	}
	```
	
	- Parameters:
		- onCompletion: Function who take a Bool for success and NSError for explanation if fail
	*/
	func fetchAllUsersFromAPI(onCompletion:((Bool,NSError!)->Void)?){
		if (onCompletion != nil){
			self.onCompletionHandler = onCompletion!
			fillUserListFromAPIAtBeginPagetoTheEnd(1)
		}
	}
	
	func groupFromResearch(value:String) -> [(String, [User])]{
		let filtredArray = self.listSearchUser.filter({$0.login.containsString(value)})
		let groupArray = filtredArray.groupBy{ (element) -> String in
			if let FirstCharaterLogin = element.login.characters.first{
				return ("\(FirstCharaterLogin)")
			}
			return ("")
		}
		let collectionArray = groupArray.sort({$0.0 < $1.0})
		return (collectionArray)
	}
	
	/**
	Put Users name and id in `nameFile` at pageNumber to the end from the API and
	fill the `listSearchUser`
	
	```
	let searchManager = ScaleTeamsManager.Shared()
	
	// Start at the first page
	searchManager.fillUserListFromAPIAtBeginPage(0)
	let myListUser = searchManager.listSearchUser
	
	// only id and login are available
	print(myListUser.id)
	print(myListUser.login)
	```
	
	- Parameters:
		- pageNumber : First page of the request
	*/
	func fillUserListFromAPIAtBeginPagetoTheEnd(pageNumber:Int){
		if let path = dir{
			apiRequester.request(UserRouter.SearchPage(pageNumber)){ (jsonDataOpt, errorOpt) in
				if let jsonData = jsonDataOpt {
					if (jsonData.arrayValue.count > 0){
						for userInfos in jsonData.arrayValue {
							
							// Catch information from user
							let user = User(jsonFetch: userInfos)
							
							// Format the Id
							let userId = ":\(user.id)"
							
							// Construct userInfos
							var userInfos = user.login
							userInfos.appendContentsOf(userId)
							print(userInfos)
							userInfos.appendContentsOf("\n")
							
							// Add data to the content file string
							self.contentFile.appendContentsOf(userInfos)
							
							// Add user in listSearchUser array
							self.listSearchUser.append(user)
							
							/**
							If searchManager have a delegate give the percent progression
							*/
							if let delegation = self.delegate {
								if let delegateCompletionPercent = delegation.searchManager {
									delegateCompletionPercent(percentOfCompletion: self.knowPercentAlpha(userInfos.lowercaseString.characters.first!))
								}
							}
						}
						// Go to the next page !
						let nextPageNumber = pageNumber + 1
						self.fillUserListFromAPIAtBeginPagetoTheEnd(nextPageNumber)
					} else {
						do {
							try self.contentFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
						} catch {
							print(NSError(domain: "Search Manager", code: -1, userInfo: [1:"error writing User list to file"]))
						}
						
					}
				} else if let error = errorOpt {
					self.onCompletionHandler(false, NSError(domain: "Search Manager", code: -1, userInfo: [1:"Error loading all the user. Dtails : \(error)."]))
				}
			}
		} else {
			self.onCompletionHandler(false, NSError(domain: "Search Manager", code: -1, userInfo: [1:"Error creating 42 users file list."]))
		}
	}
	
	/**
	Put Users name and id in `listSearchUser` from `nameFile`
	
	```
	let searchManager = ScaleTeamsManager.Shared()
	// Start at the first page
	SearchManager.fetchUsersOnAPI(0){ (success, error) in
		if (success){
			self.performSegueWithIdentifier("connectSegue", sender: self)
		} else {
			showAlertWithTitle("Loading users list", message: "A problem occured.", view: self)
		}
	}
	```
	
	- Parameters:
		- onCompletion : Function take Bool for success and NSError for explanation if fail
	*/
	func fetchUsersFromFile(onCompletion:((Bool,NSError!)->Void)?){
		if (onCompletion != nil){
			self.onCompletionHandler = onCompletion!
			fillUserListFromFile()
		}
	}
	
	/**
	Fetch `listSearchUser` with data in `nameFile`
	Data format :
	```login:id\n```
	*/
	private func fillUserListFromFile(){
		if let path = dir{
			if fileAlreadyExist() {
				do {
					let fileContent = try String(contentsOfFile: path, usedEncoding: nil)
					let InfosUsers = fileContent.componentsSeparatedByString("\n")
					for InfosUser in InfosUsers {
						if (InfosUser != ""){
							let InfoUser = InfosUser.componentsSeparatedByString(":")
							if let idUser:Int = Int(InfoUser[1]){
								listSearchUser.append(User(login: InfoUser[0], id: idUser))
							}
						}
					}
					self.onCompletionHandler(true, nil)
				} catch {
					self.onCompletionHandler(false, NSError(domain: "Search Manager", code: -1, userInfo: ["Error":"Error oppening 42 users file list."]))
				}
				return
			} else {
				self.onCompletionHandler(false, NSError(domain: "Search Manager", code: -1, userInfo: ["Error":"42 users file list not found."]))
			}
		} else {
			self.onCompletionHandler(false, NSError(domain: "Search Manager", code: -1, userInfo: ["Error":"Error on composing path"]))
		}
	}
	
	// MARK: - Private methods
	/// To know percent compared to the letter in alphabet
	private func knowPercentAlpha(letter:Character) -> Int{
		let asciiInt = letter.unicodeScalarCodePoint()
		let percent = (asciiInt - 97) * 100 / 25
		return (Int(percent))
	}
}

/// Private extension of Character object
private extension Character
{
	/// give the ASCII int of a Number
	func unicodeScalarCodePoint() -> UInt32
	{
		let characterString = String(self)
		let scalars = characterString.unicodeScalars
		
		return scalars[scalars.startIndex].value
	}
}

private extension Array{
	func groupBy<G:Hashable>(groupingclosure:(Element) -> G) -> [G:[Element]] {
		var dict = [G:[Element]]()
		for element in self{
			let key = groupingclosure(element)
			var array = dict[key]
			if array == nil {
				array = [Element]()
			}
			array?.append(element)
			dict[key] = array
		}
		return dict
	}
}
