//
//  FriendViewController.swift
//  Open42
//
//  Created by larry on 09/07/2016.
//  Copyright © 2016 42. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, MFMessageComposeViewControllerDelegate {

	// MARK: - Proprieties
	let friendsManager = FriendsManager.Shared()
	/// Name of the custom cell call by the `tableView`
	let cellName = "FriendCell"
	/// Refresh control for `tableView`
	lazy var refreshControl:UIRefreshControl = {
		let lazyRefreshControl = UIRefreshControl()
		lazyRefreshControl.attributedTitle = NSAttributedString(string: "Refresh location", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
		lazyRefreshControl.tintColor = UIColor.whiteColor()
		lazyRefreshControl.addTarget(self, action: #selector(self.refreshData), forControlEvents: UIControlEvents.ValueChanged)
		return lazyRefreshControl
	}()
	
	// MARK: - IBOutlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var howToImg: UIImageView!
	
	// MARK: - IBActions
	@IBAction func editAction(sender: UIBarButtonItem) {
			tableView.setEditing(!tableView.editing, animated: true)
	}
	
	
	// MARK: - View life cycle
	override func viewWillAppear(animated: Bool) {
		initView()
		refreshData()
	}
	
	override func viewWillDisappear(animated: Bool) {
		friendsManager.fetchedResults.delegate = nil
		tableView.setEditing(false, animated: false)
		self.refreshControl.endRefreshing()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	// MARK: - Methods
	func refreshData() {
		friendsManager.refresh(UserManager.Shared().loginUser!) { (errorOpt) in
			if let error = errorOpt {
				showAlertWithTitle("Api 42", message: "\(error.userInfo["message"])", view: self)
			} else {
				self.refreshControl.endRefreshing()
				//self.tableView.reloadData()
				self.verifieContent(false)
			}
		}
	}
	
	// MARK: - Private methods
	private func initView(){
		tableView.insertSubview(refreshControl, atIndex: 0)
		let cell = UINib(nibName: cellName, bundle: nil)
		tableView.registerNib(cell, forCellReuseIdentifier: cellName)
		tableView.delegate = self
		tableView.dataSource = self
		friendsManager.fetchedResults.delegate = self
		try! friendsManager.fetchedResults.performFetch()
		tableView.reloadData()
	}
	
	private func verifieContent(animated:Bool = true){
		var duration = 0.0
		if animated {
			duration = 0.7
		}
		dispatch_async(dispatch_get_main_queue()){
			if let list = self.friendsManager.list {
				if list.count > 0 {
					UIView.animateWithDuration(duration){
						self.howToImg.alpha = 0.0
						self.tableView.alpha = 1.0
					}
					
					return
				}
			}
			UIView.animateWithDuration(1){
				self.howToImg.alpha = 1.0
				self.tableView.alpha = 0.0
			}
		}
	}
	
	// MARK: - TableView delegation
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCellWithIdentifier(cellName) as? FriendTableViewCell,
			let friend = friendsManager.fetchedResults.objectAtIndexPath(indexPath) as? Friend{
			cell.fill(friend, view: self)
			return cell
		}
		let errorCell = UITableViewCell()
		return errorCell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let list = friendsManager.list {
			return list.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 57
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete{
			if let friend = friendsManager.fetchedResults.objectAtIndexPath(indexPath) as? Friend {
				friendsManager.remove(friend)
				verifieContent()
			}
		}
	}
	
	// MARK: - Fetch controller delegate
	/* Notifies the delegate that a fetched object has been changed due to an add, remove, move, or update. Enables NSFetchedResultsController change tracking.
	controller - controller instance that noticed the change on its fetched objects
	anObject - changed object
	indexPath - indexPath of changed object (nil for inserts)
	type - indicates if the change was an insert, delete, move, or update
	newIndexPath - the destination path for inserted or moved objects, nil otherwise
	
	Changes are reported with the following heuristics:
	
	On Adds and Removes, only the Added/Removed object is reported. It's assumed that all objects that come after the affected object are also moved, but these moves are not reported.
	The Move object is reported when the changed attribute on the object is one of the sort descriptors used in the fetch request.  An update of the object is assumed in this case, but no separate update message is sent to the delegate.
	The Update object is reported when an object's state changes, and the changed attributes aren't part of the sort keys.
	*/
	@objc func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch (type) {
		case .Insert:
			if let indexPath = newIndexPath {
				tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			}
			break;
		case .Delete:
			if let indexPath = indexPath {
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
			}
			break;
		case .Update:
			break
		case .Move:
			if let indexPath = indexPath {
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			}
			
			if let newIndexPath = newIndexPath {
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
			}
			break;
		}
	}
	
	/* Notifies the delegate that section and object changes are about to be processed and notifications will be sent.  Enables NSFetchedResultsController change tracking.
	Clients utilizing a UITableView may prepare for a batch of updates by responding to this method with -beginUpdates
	*/
	@objc func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
	}
	
	/* Notifies the delegate that all section and object changes have been sent. Enables NSFetchedResultsController change tracking.
	Providing an empty implementation will enable change tracking if you do not care about the individual callbacks.
	*/
	@objc func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
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
}
