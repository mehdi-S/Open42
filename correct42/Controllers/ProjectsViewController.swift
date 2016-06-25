//
//  ProjectsViewController.swift
//  correct42
//
//  Created by larry on 01/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
View display projects of the `currentUser` inside `UserManager`
*/
class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	// MARK: - Singletons
	/// Singleton of `UserManager`
	let currentUser = UserManager.Shared().currentUser
	
	// MARK: - Proprieties
	/// Name of the custom cell call by the `projectsTable`
	let cellName = "projectCell"
	
	/// Lazy array of all projects of `currentUser` sort by Mark
	lazy var projects:[Project] = {
		if let cursusProjects = self.currentUser?.projects{
			return (cursusProjects.sort({ $0.finalMark > $1.finalMark }))
		}
		return ([])
	}()
	
	// MARK: - IBOutlets
	/// Table view of each projects of `currentUser`
	@IBOutlet weak var projectsTable: UITableView!
	
	/// Title label of the view (generally the login of the user)
	@IBOutlet weak var titleLabel: UILabel!
	
	// MARK: - IBActions
	/// Dissmiss the project view
	@IBAction func clickBackButton(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	Change the order of `projects` and reload data in `projectsTable`
	with this model options compared with `selectedSegmentIndex` :
	
	case 0 : Sort by A-Z
	
	case 1 : Sort by Mark
	
	Default : Sort by Z-A
	
	- Parameter sender: Any `UISegmentedControl`
	*/
	@IBAction func sortBy(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			projects = projects.sort({ $0.slug < $1.slug })
			break
		case 1:
			projects = projects.sort({ $0.finalMark > $1.finalMark })
			break
		case 2:
			projects = projects.sort({ $0.slug > $1.slug })
			break
		default:
			break
		}
		projectsTable.reloadData()
	}
	
	// MARK: - View life cycle
	/**
	Register Custom cells, fill delegate and dataSource `projectsTable` by `ProjectsViewController`
	*/
    override func viewDidLoad() {
        super.viewDidLoad()
		let nib = UINib(nibName: cellName, bundle: nil)
		projectsTable.registerNib(nib, forCellReuseIdentifier: cellName)
		projectsTable.delegate = self
		projectsTable.dataSource = self
    }
	
	/**
	Set the login user in `titleLabel` like "\(currentUser.login)'s projects"
	*/
	override func viewWillAppear(animated: Bool) {
		if let currentUser = currentUser{
			titleLabel.text = "\(currentUser.login)'s projects"
		}
	}
	
	// MARK: - Table view delegation
	/**
	Count `projects` for the `projectsTable` numberOfRowsInSection.
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (projects.count)
	}
	
	/**
	Create a `ProjectTableViewCell` and fill it.
	- Returns: An `ProjectTableViewCell` filled.
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let projectCellPrototype:ProjectTableViewCell? = {
			let projectCell = self.projectsTable.dequeueReusableCellWithIdentifier(self.cellName)
			if projectCell is ProjectTableViewCell{
				return (projectCell as! ProjectTableViewCell)
			}
			return (nil)
		}()
		projectCellPrototype!.markLabel.text = "\(projects[indexPath.row].finalMark) %"
		
		if (projects[indexPath.row].finalMark >= 50){
			projectCellPrototype!.markLabel.textColor = UIColor.greenDarkColor()
		} else {
			projectCellPrototype!.markLabel.textColor = UIColor.redDarkColor()
		}
		projectCellPrototype!.projectNameLabel.text = projects[indexPath.row].slug.stringByReplacingOccurrencesOfString("-", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil).capitalizedString
			return (projectCellPrototype!)
	}

}

/// extension UIColor to define color extensions
private extension UIColor {
	/// return a little bit dark green `UIColor`
	static func greenDarkColor() -> UIColor{
		return (UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0))
	}
	
	/// return a little bit dark red `UIColor`
	static func redDarkColor() -> UIColor{
		return (UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0))
	}
}
