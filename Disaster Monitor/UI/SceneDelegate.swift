//
//  SceneDelegate.swift
//  Disaster Monitor
//
//  Created by Stefano Martina on 21/11/2019.
//  Copyright © 2019 Stefano Martina. All rights reserved.
//

import Katana
import CoreLocation
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var store: Store<AppState, DependenciesContainer>!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.disastermonitor.refresh", using: nil) { (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        let interceptor = PersistorInterceptor.interceptor()
        store = Store<AppState, DependenciesContainer>(interceptors: [interceptor])
                
        store.dispatch(InitAppState())
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let tabBarController = MainTabBarController(store: store)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        scheduleAppRefresh()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.disastermonitor.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print(error)
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        let queue = OperationQueue()
        scheduleAppRefresh()
        queue.maxConcurrentOperationCount = 1
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        queue.addOperation {
            
            if self.store.state.debugMode {
                print("debug mode attiva")
                // l'identifier della region non deve essere per forza uguale a quello della notifica!
                let region: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(-56.072800, -27.595400), radius: 10000.0, identifier: "region")
                for event in self.store.state.events {
                    let coo = CLLocationCoordinate2D(latitude: event.coordinates[1], longitude: event.coordinates[0])
                    if region.contains(coo) {
                        let center = UNUserNotificationCenter.current()
                        
                        let content = UNMutableNotificationContent()
                        content.title = "test"
                        content.body = "You've entered a new region"
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
                        
                        //center.removeAllPendingNotificationRequests()
                        //center.removeAllDeliveredNotifications()
                        center.add(notificationRequest, withCompletionHandler: { (error) in
                            if let error = error {
                                // Something went wrong
                                print(error)
                            }
                            else{
                                print("added")
                            }
                        })
                    }
                }
            }
            else {
                print("debug mode NON attiva")
            }
            
        }
        
        let op = queue.operations.first!

        op.completionBlock = {
            task.setTaskCompleted(success: !op.isCancelled)
        }
    }

}
