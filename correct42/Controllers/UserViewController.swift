//
//  UserViewController.swift
//  correct42
//
//  Created by larry on 30/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit
import MessageUI

/**
Container content of an displayed user
Display all public informations
Implementation of click on `mobileLabel` and `emailLabel`
to interpret and do the correspondant action
*/
class UserViewController: UIViewController, UIGestureRecognizerDelegate, MFMessageComposeViewControllerDelegate{

	// MARK: - Singletons
	/// Singleton of `UserManager`
	var user = UserManager.Shared()
	/// Singleton of `ApiRequester`
	var apiRequester = ApiRequester.Shared()
	
	// MARK: - IBOutlets
	/// Image view of the `userManager.currentUser`.
	@IBOutlet weak var userImage: UIImageView!
	
	/// Login label of the `userManager.currentUser`.
	@IBOutlet weak var pseudoLabel: UILabel!
	
	/// Mobile TextView of the `userManager.currentUser`.
	@IBOutlet weak var mobileLabel: UILabel!
	
	/// Email label of the `userManager.currentUser`.
	@IBOutlet weak var emailLabel: UILabel!
	
	/// Level label of the `userManager.currentUser`.
	@IBOutlet weak var levelLabel: UILabel!
	
	/// Wallet label of the `userManager.currentUser`.
	@IBOutlet weak var walletsLabel: UILabel!
	
	/// Correction points label of the `userManager.currentUser`.
	@IBOutlet weak var pointsLabel: UILabel!
	
	/// Location in 42 School label of the `userManager.currentUser`.
	@IBOutlet weak var locationLabel: UILabel!
	
	// MARK: - IBActions
	/// Perform segue with id:  `goToProjects`.
	@IBAction func ClickButtonProjects(sender: UIButton) {
		self.performSegueWithIdentifier("goToProjects", sender: self)
	}
	
	/// Perform segue with id:  `goToSkills`.
	@IBAction func ClickButtonSkills(sender: UIButton) {
		self.performSegueWithIdentifier("goToSkills", sender: self)
	}

	// MARK: - View life cycle
	/// Define cornerRadius of the image.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		defineDefaultDesign()
		appendDefaultGestureReconizer()
    }
	
	/// Ask to fill information from `userManager.currentUser`.
	override func viewWillAppear(animated: Bool) {
		fillUser()
	}
	
	// MARK: - MFMessage Compose View Controller Delegate
	/// Message compose handler.
	func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
		switch (result) {
		case MessageComposeResultCancelled:
			self.dismissViewControllerAnimated(true, completion: nil)
		case MessageComposeResultFailed:
			self.dismissViewControllerAnimated(true, completion: nil)
		case MessageComposeResultSent:
			self.dismissViewControllerAnimated(true, completion: nil)
		default:
			break;
		}
	}

	
	// MARK: - Private methods
	/**
	If Fill information from `userManager.currentUser` else if he's optionnal
	fill view with defaults values.
	*/
	private func fillUser(){
		if let currentUser = user.currentUser{
			fillImage(currentUser.imageUrl)
			pseudoLabel.text = currentUser.login
			emailLabel.text = currentUser.email
			mobileLabel.text = currentUser.phone
			walletsLabel.text = "\(currentUser.wallet) ₳"
			pointsLabel.text = "\(currentUser.correctionPoint)"
			if currentUser.location != "" {
				locationLabel.text = currentUser.location
			} else {
				locationLabel.text = "-"
			}
			if let cursus = currentUser.cursus.first{
				levelLabel.text = "\(cursus.level)%"
			}
		} else {
			userImage.image = nil
			pseudoLabel.text = "Unknown"
			emailLabel.text = "Unknown"
			mobileLabel.text = "Unknown"
			walletsLabel.text = "0 ₳"
			pointsLabel.text = "0"
			locationLabel.text = "-"
			levelLabel.text = "0%"
		}
	}
	
	/**
	Take an imageUrl and downloadImage with `apiRequester.downloadImage` 
	and fill `userImage` with result on success.
	*/
	private func fillImage(imageUrl:String){
		apiRequester.downloadImage(imageUrl, success: { (image) in
				self.userImage.image = image
			}, failure: { (error) in
				print(error.domain)
		})
	}
	
	/**
	Purpose two choice with action sheet:
		1. Call the phone number inside `mobileLabel` if exist else nothing happen.
		2.
	*/
	@objc private func clicPhoneNumber(){
		if (!user.currentIsProfil){
			if var phoneNumber = self.mobileLabel.text {
				phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("(", withString: "")
				phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(")", withString: "")
				phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
				phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(".", withString: "")
				phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
					
				let alert = UIAlertController(title: "\(self.user.currentUser!.firstName)'s Contacts", message: "What do you want to do with the number phone of \(self.user.currentUser!.firstName) ?", preferredStyle: .ActionSheet)
				
				alert.addAction(UIAlertAction(title: "Call", style: .Default, handler: { (alertAction) in
					if let phoneNumberURL = NSURL(string: "tel://\(phoneNumber)"){
						UIApplication.sharedApplication().openURL(phoneNumberURL)
					}
				}))
				
				alert.addAction(UIAlertAction(title: "Sms", style: .Default, handler: { (alertAction) in
						let messageVC = MFMessageComposeViewController()
						messageVC.body = "Salutation \(self.user.currentUser!.firstName),";
						messageVC.recipients = [phoneNumber]
						messageVC.messageComposeDelegate = self;
						
						self.presentViewController(messageVC, animated: false, completion: nil)
				}))
				
				alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
	}
	
	/**
	Call the phone number inside `mobileLabel` if exist else nothing happen.
	*/
	@objc private func clicEmail(){
		if (!user.currentIsProfil){
			if let email = emailLabel.text {
				if email.containsString("@student.42.fr") {
					if let email = NSURL(string: "mailto://\(email)"){
						UIApplication.sharedApplication().openURL(email)
					}
				}
			}
		}
	}
	
	/**
	Append default Gesture reconizer. Need to add interpretation
	of label inside an profil user. Follow actions happens :
	- `mobileLabel` tap gesture do the `clicPhoneNumber` action method
	- `emailLabel` tap gesture do the `clicEmail` action method
	*/
	private func appendDefaultGestureReconizer() {
		/// For `mobileLabel`
		let tapPhone = UITapGestureRecognizer(target: self, action: #selector(self.clicPhoneNumber))
		mobileLabel.addGestureRecognizer(tapPhone)
		/// For `emailLabel`
		let tapEmail = UITapGestureRecognizer(target: self, action: #selector(self.clicEmail))
		emailLabel.addGestureRecognizer(tapEmail)
	}
	
	/**
	Define the default design of `UserViewController`
	Follow designs will be set :
	- `userImage` will draw inside a circle
	*/
	private func defineDefaultDesign() {
		// Define userImage circle
		userImage.layer.cornerRadius = userImage.frame.size.width/2
		userImage.clipsToBounds = true
	}
}
