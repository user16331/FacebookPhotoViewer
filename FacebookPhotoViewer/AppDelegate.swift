//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit
import FBSDKLoginKit

/// PhotoBrowser application delegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Application main window
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        if FBSession.isLoggedIn {
            ApplicationController.shared.openAlbumList(animated: false)
        }

        return true
    }
}

