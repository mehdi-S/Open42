//
//  SearchManagerDelegation.swift
//  correct42
//
//  Created by larry on 24/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import Foundation

/// Delegate fonctionnality of the SearchManager to a Controller
@objc protocol SearchManagerDelegation {
	/// To know where is the searchManager when he do `fetchUsersOnAPI`
	optional func searchManager(percentOfCompletion percent:Int)
}
