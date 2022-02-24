//
//  AppDelegate.swift
//  MarvelApp
//
//  Created by C94280a on 18/11/21.
//

import UIKit
import CoreData
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let tag = TaggingFirebase()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let viewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        tag.tagUserId(userId: Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String)
        tag.tagPropertyId(value: "comida_favorita", forName: "Banana")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DataBaseController.saveContext()
    }
    
}
