//
//  ScaleTeamTableViewCell.swift
//  correct42
//
//  Created by larry on 15/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit

/**
`UITableViewCell` inheritance for a ScaleTeam cell
*/
class ScaleTeamTableViewCell: UITableViewCell {

	// MARK: - Proprieties
	/// Label center inside a subview
	@IBOutlet weak var allText: UILabel!
	
	// MARK: - Methods
	/**
	Fill the `allText` Label with the correspondant text. Give basics information about a scaleTeam
	
	- Parameter owner: True if the token owner will be corrected
	- Parameter correctedLogin: Login of the user concerned. Can be nil if this user is invisible, he will be replacing by "someone".
	- Parameter date: NSDate `beginDate` of the scale team
	- Parameter projectName: Name of the project of the scale inside the scale team
	*/
	func setText(owner:Bool, correctedLogin:String?, date:NSDate, projectName:String){
		var correctedLoginCheck = correctedLogin
		if (correctedLogin == nil){
			correctedLoginCheck = "someone"
		}
		let dateFormat = NSDateFormatter()
		dateFormat.locale = NSLocale(localeIdentifier: "fr_FR")
		dateFormat.dateFormat = "'on' dd/LL/yyyy 'at' HH:mm"
		var text = "You'll correct \(correctedLoginCheck!) \n\(dateFormat.stringFromDate(date))\nfor \(projectName)"
		if owner{
			text = "You'll be corrected by \(correctedLoginCheck!)\n\(dateFormat.stringFromDate(date))\n for \(projectName)"
		}
		allText.text = text
	}
}
