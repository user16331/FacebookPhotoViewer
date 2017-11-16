//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation
import FBSDKLoginKit

/// Get Facebook photos list Request
internal class FBGetAlbumPhotosListRequest: FBRequest {

    /// Type of request successfull result
    internal typealias Result = [FBPhoto]

    /// Identifier of the album
    internal let albumId: String

    /// Returns initialized request instance
    internal init(albumId: String) {
        self.albumId = albumId
    }

    /// Execute request
    internal func execute(_ callback: @escaping ([FBPhoto], FBRequestError?) -> Void) {
        guard FBSession.isLoggedIn else {
            callback([], .notLoggedIn)
            return
        }

        let graphRequest = FBSDKGraphRequest(graphPath: "/\(self.albumId)/photos", parameters: [:])
        guard graphRequest != nil else {
            callback([], .general)
            return
        }

        graphRequest!.start(completionHandler: { (_, result, error) in
            guard error == nil else {
                callback([], .sdk(error!))
                return
            }

            var photos = [FBPhoto]()
            if let result = result as? [String: Any] {
                if let resultPhotos = result["data"] as? [[String: Any]] {
                    for resultPhoto in resultPhotos {
                        if let resultPhotoId = resultPhoto["id"] as? String {
                            let resultPhotoName = resultPhoto["name"] as? String
                            let photo = FBPhoto(id: resultPhotoId, name: resultPhotoName)
                            photos.append(photo)
                        }
                    }
                }
            }
            callback(photos, nil)
        })
    }
}

