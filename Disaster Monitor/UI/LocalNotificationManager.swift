//
//  LocalNotificationManager.swift
//  Disaster Monitor
//
//  Created by Francesco Peressini on 04/04/2020.
//  Copyright © 2020 Stefano Martina. All rights reserved.
//

import CoreLocation
import UserNotifications

final class LocalNotificationsManager {
    
    @discardableResult
    static func scheduleEventNotification(events: [Event], places: [Region]) -> [Event] {
        
        var notifiedEvents = [Event]()
        
        if places.isEmpty {
            return notifiedEvents
        }
        
        for place in places {
            let placeCoordinates = CLLocation(latitude: place.latitude, longitude: place.longitudine)
            for event in events {
                if event.date < place.dateAdded || notifiedEvents.contains(event) || event.hasBeenNotified == true {
                    continue
                }
                else {
                    let eventCoordinates = CLLocation(latitude: event.coordinates[1], longitude: event.coordinates[0])
                    
                    // Distanza in km
                    let distance = placeCoordinates.distance(from: eventCoordinates) / 1000
                    
                    if distance <= place.distance && event.magnitudo >= place.magnitude {
                        // Sicuramente non il posto giusto dove fare questo append
                        notifiedEvents.append(event)
                        
                        let center = UNUserNotificationCenter.current()
                        
                        let content = UNMutableNotificationContent()
                        content.title = "Seismic event detected"
                        content.body = "Seismic event detected near \(place.name): \(event.name) with magnitude \(event.magnitudo)"
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        
                        let notificationRequest: UNNotificationRequest = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)
                        
                        center.add(notificationRequest, withCompletionHandler: { (error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("[Async] Notification added (ID: \(notificationRequest.identifier))")
                            }
                        })
                    }
                }
            }
        }
        print("Number of notifications scheduled: \(notifiedEvents.count)")
        return notifiedEvents
    }
    
}
