//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit

/// Application controller.
/// This class helps to easily navigate between application screens.
/// It can handle application level events in the future if needed.
internal class ApplicationController {

    private init() {
    }

    /// Returns main UINavigationController controller from a view hierarchy
    private var navigationController: UINavigationController {
        let delegate = UIApplication.shared.delegate!
        let window = delegate.window!!
        let navigationController = window.rootViewController as! UINavigationController

        return navigationController
    }

    /// Returns main UIStoryboard
    private var storyboard: UIStoryboard {
        let delegate = UIApplication.shared.delegate!
        let window = delegate.window!!
        let storyboard = window.rootViewController?.storyboard

        return storyboard!
    }

    /// Returns ApplicationController shared instance
    internal static let shared = ApplicationController()

    /// Open view with Facebook albums
    internal func openAlbumList(animated: Bool) {
        let albumListViewController = self.storyboard.instantiateViewController(withIdentifier: "AlbumList")
        self.navigationController.pushViewController(albumListViewController, animated: animated)
    }

    /// Open view with photos of the given Facebook album
    internal func openAlbumPhotoList(albumId: String, animated: Bool) {
        let albumPhotoListViewController = self.storyboard.instantiateViewController(withIdentifier: "AlbumPhotoList") as! AlbumPhotoListViewController
        albumPhotoListViewController.albumId = albumId
        self.navigationController.pushViewController(albumPhotoListViewController, animated: animated)
    }

    /// Open view with a given image displayed in fullscreen
    internal func openImageInFullscreen(_ image: UIImage) {
        let fullscreenImageViewController = self.storyboard.instantiateViewController(withIdentifier: "FullscreenImage") as! FullscreenImageViewController
        fullscreenImageViewController.image = image
        self.navigationController.pushViewController(fullscreenImageViewController, animated: true)
    }

    /// Display alert message view
    internal func displayAlertView(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("Alert action OK", comment: "Alert view"), style: .default)
        alertController.addAction(OKAction)

        self.navigationController.topViewController?.present(alertController, animated: true)
    }

    /// Pop last displayed view from a view hierarchy
    internal func closeCurrentView() {
        self.navigationController.popViewController(animated: true)
    }
}
