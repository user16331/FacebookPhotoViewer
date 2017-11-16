//
//  Copyright © 2017 user16331. All rights reserved.
//

import UIKit

/// 'Image displayed in fullscreen' view controller
internal class FullscreenImageViewController: UIViewController {

    /// UIImageView with a displayed image
    @IBOutlet weak var imageView: UIImageView!

    /// Image displayed in fullscreen
    internal var image: UIImage!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.imageView.image = self.image
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
