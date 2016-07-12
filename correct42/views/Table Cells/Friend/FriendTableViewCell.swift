//
//  FriendTableViewCell.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit
import MessageUI

class FriendTableViewCell: UITableViewCell {

	// MARK: - Proprieties
	/// Friends diplayed inside the cell
	var cellFriendOpt:Friend?
	/// View use to present message view controller or Alerts.
	var viewOpt:FriendViewController?
	
	// MARK: - IBOutlets
	/// Login or Surname of the `cellFriendOpt`
	@IBOutlet weak var loginOrSurnameLabel: UILabel!
	/// Location of the `cellFriendOpt`
	@IBOutlet weak var locationLabel: UILabel!
	/// Image of the `cellFriendOpt`
	@IBOutlet weak var imageFriendView: UIImageView!
	
	// MARK: - IBActions
	/// Call the friend if the number are available and well formated.
	@IBAction func callAction(sender: UIButton) {
		if let phoneNumber = formatPhoneNumber() {
			if let phoneNumberURL = NSURL(string: "tel://\(phoneNumber)"){
				UIApplication.sharedApplication().openURL(phoneNumberURL)
			}
		} else {
			if let view = viewOpt {
				showAlertWithTitle("Open 42 SMS", message: "Le numéro n'est pas disponible ou dans un format inconnu.", view: view)
			}
		}
	}

	/// Display messenger to send sms if the number are available and well formated
	@IBAction func smsAction(sender: UIButton) {
		if let phoneNumber = formatPhoneNumber(), let view = viewOpt {
			let messageVC = MFMessageComposeViewController()
			if MFMessageComposeViewController.canSendText() {
				messageVC.body = "";
				messageVC.recipients = [phoneNumber]
				messageVC.messageComposeDelegate = view;
				view.presentViewController(messageVC, animated: true, completion: nil)
			}
		} else {
			if let view = viewOpt {
				showAlertWithTitle("Open 42 SMS", message: "The number is unknow or badly formated", view: view)
			}
		}
	}
	
	// MARK: - Cell life cycle
	/// Init radius corner of the `imageFriendView`
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		imageFriendView.layer.cornerRadius = imageFriendView.frame.size.width / 2;
		imageFriendView.clipsToBounds = true;
    }
	
	// MARK: - Methods
	/// Fill the cell, keep friend inside `cellFirendOpt` and view into `viewOpt`.
	func fill(friend:Friend, view:FriendViewController){
		cellFriendOpt = friend
		viewOpt = view
		if let cellFriend = cellFriendOpt {
			if let surname = cellFriend.surname {
				loginOrSurnameLabel.text = surname
			} else {
				loginOrSurnameLabel.text = cellFriend.login
			}
			
			if cellFriend.location != nil && cellFriend.location != "" {
				locationLabel.text = cellFriend.location
			} else {
				locationLabel.text = "Not connected"
			}
			
			if let imageUrl = cellFriend.imageUrl {
				ApiRequester.Shared().downloadImage(imageUrl, success: { (image) in
					self.imageFriendView.image = image
				}){
					(error) in
					self.imageFriendView.image = nil
					print("Impossible to fetch image for \(cellFriend.login).")
				}
			}
		}
	}
	
	// MARK: - Private methods
	/// Check and format phone number.
	private func formatPhoneNumber() -> String?{
		if var phoneNumber = cellFriendOpt?.phoneNumber where cellFriendOpt?.phoneNumber != "" {
			phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("(", withString: "")
			phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(")", withString: "")
			phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
			phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(".", withString: "")
			phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
			return phoneNumber
		}
		return nil
	}
}
