//
//  SuperModel.swift
//  correct42
//
//  Created by larry on 25/04/2016.
//  Copyright © 2016 42. All rights reserved.
//

import SwiftyJSON

/// Use to keep data from json to define lazy var in inheritence
class SuperModel {
	
	/// Parsed JSON Data
	var jsonData:JSON = JSON("")
	
	/**
	Set `jsonData`
	- Parameter jsonFetch: Any `JSON` object conform to inheritence
	*/
	required init(jsonFetch:JSON){
		print(jsonFetch)
		jsonData = jsonFetch
	}
}