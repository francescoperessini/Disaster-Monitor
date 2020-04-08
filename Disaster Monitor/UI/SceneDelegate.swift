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
    var lastCleaned: Date?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.disastermonitor.db_cleaning", using: nil) { (task) in
            self.handleDbCleaning(task: task as! BGProcessingTask)
        }
        
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
        scheduleDatabaseCleaningIfNeeded()
    }
    
    func scheduleDatabaseCleaningIfNeeded(){
        /*let now = Date()
         let oneWeek = TimeInterval(7 * 24 * 60 * 60)
         
         guard now > (self.lastCleaned ?? Date() + oneWeek) else {return}*/
        
        let request = BGProcessingTaskRequest(identifier: "com.disastermonitor.db_cleaning")
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background database cleaning (try on a real device and not on the simulator!)")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.disastermonitor.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background events refresh (try on a real device and not on the simulator!)")
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
                print("Debug mode activated")
                self.store.dispatch(AddDebugEvent(id: "test_background", name: "Test Earthquake Background"))
            }
            else {
                print("Debug mode not activated")
                self.store.dispatch(GetEvents())
            }
        }
        
        let op = queue.operations.first!
        
        op.completionBlock = {
            task.setTaskCompleted(success: !op.isCancelled)
        }
    }
    
    func handleDbCleaning(task: BGProcessingTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        queue.addOperation {
            self.store.dispatch(DeleteOlder())
        }
        
        let op = queue.operations.first!
        
        op.completionBlock = {
            task.setTaskCompleted(success: !op.isCancelled)
        }
    }
    
}
