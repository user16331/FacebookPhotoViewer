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
    private var navigationController: UINavigationController? {
        return self.applicationDelegate?.window??.rootViewController as? UINavigationController
    }

    /// Returns main UIStoryboard
    private var storyboard: UIStoryboard? {
        return self.applicationDelegate?.window??.rootViewController?.storyboard
    }

    /// Returns ApplicationController shared instance
    internal static let shared = ApplicationController()

    /// Application delegate (real delegate can be substituted if needed)
    internal var applicationDelegate: UIApplicationDelegate?

    /// Open view with Facebook albums
    internal func openAlbumList(animated: Bool) {
        let albumListViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumList")
        assert(albumListViewController != nil)

        if let albumListViewController = albumListViewController {
            assert(self.navigationController != nil)
            self.navigationController?.pushViewController(albumListViewController, animated: animated)
        }
    }

    /// Open view with photos of the given Facebook album
    internal func openAlbumPhotoList(albumId: String, animated: Bool) {
        let albumPhotoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumPhotoList") as? AlbumPhotoListViewController
        assert(albumPhotoListViewController != nil)

        if let albumPhotoListViewController = albumPhotoListViewController {
            albumPhotoListViewController.albumId = albumId

            assert(self.navigationController != nil)
            self.navigationController?.pushViewController(albumPhotoListViewController, animated: animated)
        }
    }

    /// Open view with a given image displayed in fullscreen
    internal func openPhotoInFullscreen(photoId: String) {
        let fullscreenPhotoViewController = self.storyboard?.instantiateViewController(withIdentifier: "FullscreenPhoto") as? FullscreenPhotoViewController
        assert(fullscreenPhotoViewController != nil)

        if let fullscreenPhotoViewController = fullscreenPhotoViewController {
            fullscreenPhotoViewController.photoId = photoId

            assert(self.navigationController != nil)
            self.navigationController?.pushViewController(fullscreenPhotoViewController, animated: true)
        }
    }

    /// Display alert message view
    internal func displayAlertView(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("Alert action OK", comment: "Alert view"), style: .default)
        alertController.addAction(OKAction)

        assert(self.navigationController != nil)
        self.navigationController?.topViewController?.present(alertController, animated: true)
    }

    /// Pop last displayed view from a view hierarchy
    internal func closeCurrentView() {
        assert(self.navigationController != nil)
        self.navigationController?.popViewController(animated: true)
    }
}
