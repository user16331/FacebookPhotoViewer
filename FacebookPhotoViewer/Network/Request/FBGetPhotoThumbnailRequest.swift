//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation
import FBSDKLoginKit

/// Get Facebook photo thumbnail Request
internal class FBGetPhotoThumbnailRequest: FBRequest {

    /// Type of request successfull result
    internal typealias Result = UIImage?

    /// Identifier of the photo
    internal let photoId: String

    /// Returns initialized request instance
    internal init(photoId: String) {
        self.photoId = photoId
    }

    /// Execute request
    internal func execute(_ callback: @escaping (UIImage?, FBRequestError?) -> Void) {
        guard let tokenString = FBSDKAccessToken.current()?.tokenString else {
            callback(nil, .notLoggedIn)
            return
        }

        guard let url = URL(string: "https://graph.facebook.com/\(self.photoId)/picture?type=thumbnail&return_ssl_resources=1&access_token=\(tokenString)") else {
            callback(nil, .general)
            return
        }

        URLSession.shared.dataTask(
            with: url,
            completionHandler: { (data, response, error) -> Void in
                guard error == nil else {
                    callback(nil, .sdk(error!))
                    return
                }

                guard let data = data else {
                    callback(nil, .zeroBinaryData)
                    return
                }

                guard let image = UIImage(data: data) else {
                    callback(nil, .invalidImageData)
                    return
                }

                callback(image, nil)
        }).resume()
    }
}
