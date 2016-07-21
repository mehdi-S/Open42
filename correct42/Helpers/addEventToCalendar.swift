//
//  addEventToCalendar.swift
//  correct42
//
//  Created by larry on 26/05/2016.
//  Copyright © 2016 42. All rights reserved.
//

import EventKit

/**
Add an Event to the default IOS Calendar set in iphone settings

```
let dateFormatter = NSDateFormatter()
dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
dateFormatter.dateFormat = "yyyy-LL-dd'T'HH:mm:ss'.'SSSz"
if let startDate = dateFormatter.dateFromString(myBegin){
addEventToCalendar(title: curScaleTeam.scale.name, description: "", startDate: startDate, endDate: startDate.dateByAddingTimeInterval(1/4 * 60 * 60), onCompletion: { (success, error) in
if (!success){
		showAlertWithTitle("Corrections", message: "Oups ! A problem occured.", view: self)
	} else {
		Print("Error !")
	})
} else {
	print("Date formatting fail...")
}

```

- Parameters:
	- title: Title of the event in the calendar.
	- description: Description of the event in the calendar.
	- startDate: Start `NSDate` point of the event in the calendar
	- endDate: ViewController who displaying the popup
	- onCompletion: Can be nil, need a function who take a Bool for success and NSError for explanation if fail 

*/
func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, onCompletion: ((success: Bool, error: NSError?) -> Void)? = nil) {
	let eventStore = EKEventStore()
	
	eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
		if (granted) && (error == nil) {
			let event = EKEvent(eventStore: eventStore)
			event.title = title
			event.startDate = startDate
			event.endDate = endDate
			event.notes = description
			event.calendar = eventStore.defaultCalendarForNewEvents
			do {
				try eventStore.saveEvent(event, span: .ThisEvent)
			} catch let e as NSError {
				onCompletion?(success: false, error: e)
				return
			}
			onCompletion?(success: true, error: nil)
		} else {
			onCompletion?(success: false, error: error)
		}
	})
}