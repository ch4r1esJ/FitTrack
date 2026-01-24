//
//  SceneDelegate.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/3/26.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        window = UIWindow(windowScene: windowsScene)
        
        let authDIContainer = AppDIContainer()
        
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        
        appCoordinator = AppCoordinator(
            navigationController: navController,
            authDIContainer: authDIContainer
        )
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        appCoordinator?.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        if url.scheme == "fittrack" {
            handleDeepLink(url: url)
        }
    }
    
    private func handleDeepLink(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        switch components.host {
        case "complete-set":
            NotificationCenter.default.post(name: NSNotification.Name("CompleteSetFromWidget"), object: nil)
            
        case "adjust-rest":
            if let adjustmentString = components.queryItems?.first(where: { $0.name == "adjustment" })?.value,
               let adjustment = Int(adjustmentString) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("AdjustRestTimeFromWidget"),
                    object: nil,
                    userInfo: ["adjustment": adjustment]
                )
            }
            
        case "skip-rest":
            NotificationCenter.default.post(name: NSNotification.Name("SkipRestFromWidget"), object: nil)
            
        case "add-exercise":
            print("Navigate to add exercise")
            
        default:
            break
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }
}
