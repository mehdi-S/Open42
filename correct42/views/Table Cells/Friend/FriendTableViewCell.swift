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
	var cellFriendOpt:Friend?
	var viewOpt:FriendViewController?
	
	// MARK: - IBOutlets
	@IBOutlet weak var loginOrSurnameLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var imageFriendView: UIImageView!
	
	// MARK: - IBActions
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

	@IBAction func smsAction(sender: UIButton) {
		if let phoneNumber = formatPhoneNumber(), let view = viewOpt {
			let messageVC = MFMessageComposeViewController()
			messageVC.body = "";
			messageVC.recipients = [phoneNumber]
			messageVC.messageComposeDelegate = view;
			if messageVC.canBecomeFirstResponder() {
				view.presentViewController(messageVC, animated: true, completion: nil)
			}
		} else {
			if let view = viewOpt {
				showAlertWithTitle("Open 42 SMS", message: "Le numéro n'est pas disponible ou dans un format inconnu.", view: view)
			}
		}
	}
	
	// MARK: - Cell life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		imageFriendView.layer.cornerRadius = imageFriendView.frame.size.width / 2;
		imageFriendView.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

	
	// MARK: - Methods
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
