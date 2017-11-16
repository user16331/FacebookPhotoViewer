//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit
import FBSDKLoginKit

/// 'Log in to Facebook' view controller
internal class LoginViewController: UIViewController {

    /// Label with application name
    @IBOutlet weak var applicationNameLabel: UILabel!

    /// Label with log in or log out hint to a user
    @IBOutlet fileprivate weak var hintLabel: UILabel!

    // Returns loaded from Storyboard view controller instance
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.onFBSessionChanged),
                                               name: NSNotification.Name.FBSDKAccessTokenDidChange,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.FBSDKAccessTokenDidChange,
                                                  object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
    }

    /// Callback which is invoked when Facebook session changes (token is acquired or removed)
    @objc internal func onFBSessionChanged() {
        if self.isViewLoaded {
            self.updateUI()

            if FBSession.isLoggedIn {
                ApplicationController.shared.openAlbumList(animated: false)
            }
        }
    }

    /// Update UI controls state
    @objc internal func updateUI() {
        self.applicationNameLabel.text = NSLocalizedString("Application Name", comment: "Login view")

        if FBSession.isLoggedIn {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Open albums navigation button title", comment: "Navigation bar"),
                                                                     style: .done,
                                                                     target: self,
                                                                     action: #selector(LoginViewController.didTapOpenAlbums))
            self.hintLabel.text = NSLocalizedString("Log out hint message", comment: "Login view")
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationItem.rightBarButtonItem = nil
            self.hintLabel.text = NSLocalizedString("Log in hint message", comment: "Login view")
        }
    }

    /// Callback which is invoked when user taps 'Open Albums' button
    @objc private func didTapOpenAlbums() {
        ApplicationController.shared.openAlbumList(animated: true)
    }
}

