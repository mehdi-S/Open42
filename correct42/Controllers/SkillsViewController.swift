//
//  SkillsViewController.swift
//  correct42
//
//  Created by larry on 01/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
View display skills of the `currentUser` inside `UserManager`
*/
class SkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

	// MARK: - Singletons
	/// Singleton of `UserManager`
	let userManager = UserManager.Shared().currentUser
	
	// MARK: - Proprieties
	/// Name of the custom cell call by the `skillsTable`
	let cellName = "skillCell"
	
	/// Lazy array of all skills of `currentUser` sort by Mark
	lazy var skills:[Skill] = {
		if let cursusSkills = self.userManager?.cursus.first?.skills{
			return (cursusSkills.sort({ $0.level > $1.level }))
		}
		return ([])
	}()
	
	// MARK: - IBOutlets
	/// Table view of each skills of `currentUser`
	@IBOutlet weak var skillsTable: UITableView!
	
	/// Title label of the view (generally the login of the user)
	@IBOutlet weak var titleLabel: UILabel!
	
	// MARK: - IBActions
	/**
	Change the order of `skills` and reload data in `skillsTable`
	with this model options compared with `selectedSegmentIndex` :
	
	case 0 : Sort by A-Z
	
	case 1 : Sort by Mark
	
	Default : Sort by Z-A
	
	- Parameter sender: Any `UISegmentedControl`
	*/
	@IBAction func sortBy(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			skills = skills.sort({ $0.name < $1.name })
			break
		case 1:
			skills = skills.sort({ $0.level > $1.level })
			break
		case 2:
			skills = skills.sort({ $0.name > $1.name })
			break
		default:
			break
		}
		skillsTable.reloadData()
	}
	
	@IBAction func clickBackButton(sender: UIButton)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	// MARK: - View life cycle
	/**
	Register Custom cells, fill delegate and dataSource `skillsTable` by `SkillsViewController`
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		let nib = UINib(nibName: cellName, bundle: nil)
		skillsTable.registerNib(nib, forCellReuseIdentifier: cellName)
		skillsTable.delegate = self
		skillsTable.dataSource = self
	}
	
	/**
	Set the login user in `titleLabel` like "\(currentUser.login)'s skills"
	*/
	override func viewWillAppear(animated: Bool) {
		if let currentUser = userManager{
			titleLabel.text = "\(currentUser.login)'s skills"
		}
	}

	// MARK: - TableView delegation
	/**
	Count `skills` for the `skillsTable` numberOfRowsInSection.
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (skills.count)
	}
	
	/**
	Create a `ProjectTableViewCell` and fill it.
	- Returns: A new `ProjectTableViewCell` filled.
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let skillCellPrototype:SkillTableViewCell? = {
			let skillCell = self.skillsTable.dequeueReusableCellWithIdentifier(self.cellName)
			if skillCell is SkillTableViewCell{
				return (skillCell as! SkillTableViewCell)
			}
			return (nil)
		}()
		
		skillCellPrototype!.levelLabel.text = "\(skills[indexPath.row].level)"
		skillCellPrototype!.skillNameLabel.text = skills[indexPath.row].name
		
		return (skillCellPrototype!)
	}
}
