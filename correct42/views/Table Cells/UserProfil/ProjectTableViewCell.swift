//
//  ProjectTableViewCell.swift
//  correct42
//
//  Created by larry on 01/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
`UITableViewCell` inheritance for a Project cell
*/
class ProjectTableViewCell: UITableViewCell {

	/// Slug name of a project
	@IBOutlet weak var projectNameLabel: UILabel!
	
	/// Final mark of a project
	@IBOutlet weak var markLabel: UILabel!

}
