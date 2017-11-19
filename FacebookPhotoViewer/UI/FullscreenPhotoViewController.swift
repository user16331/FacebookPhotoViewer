//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit

/// 'Image displayed in fullscreen' view controller
internal class FullscreenPhotoViewController: UIViewController {

    /// UIImageView with a displayed image
    @IBOutlet weak var imageView: UIImageView!

    /// UIActivityIndicatorView for full-size image loading
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!

    /// Identifier of the loading image
    internal var photoId: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        if let loadingPhotoId = self.photoId {
            self.imageView.isHidden = true

            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.startAnimating()

            FBGetPhotoRequest(photoId: loadingPhotoId).execute({ (image, error) in
                DispatchQueue.main.async {
                    if loadingPhotoId == self.photoId {
                        self.imageView.isHidden = false
                        self.imageView.image = image

                        self.loadingIndicatorView.stopAnimating()
                        self.loadingIndicatorView.isHidden = true
                    }
                }
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    /// Callback which is invoked when user taps Close button
    @IBAction func didTapCross(_ sender: Any) {
        ApplicationController.shared.closeCurrentView()
    }
}
