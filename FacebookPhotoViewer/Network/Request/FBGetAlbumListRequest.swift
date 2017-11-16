//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation
import FBSDKLoginKit

/// Get Facebook album list Request
internal class FBGetAlbumListRequest: FBRequest {

    /// Type of request successfull result
    internal typealias Result = [FBAlbum]

    /// Execute request
    internal func execute(_ callback: @escaping ([FBAlbum], FBRequestError?) -> Void) {
        guard FBSession.isLoggedIn else {
            callback([], .notLoggedIn)
            return
        }

        let graphRequest = FBSDKGraphRequest(graphPath: "/me/albums?fields=name,cover_photo,count", parameters: [:])
        guard graphRequest != nil else {
            callback([], .general)
            return
        }

        graphRequest!.start(completionHandler: { (_, result, error) in
            guard error == nil else {
                callback([], .sdk(error!))
                return
            }

            var albums = [FBAlbum]()
            if let result = result as? [String: Any] {
                if let resultAlbums = result["data"] as? [[String: Any]] {
                    for resultAlbum in resultAlbums {
                        if let resultAlbumId = resultAlbum["id"] as? String {
                            let resultAlbumName = resultAlbum["name"] as? String
                            let resultCoverPhoto = resultAlbum["cover_photo"] as? [String: Any]
                            let resultCoverPhotoId = resultCoverPhoto?["id"] as? String
                            let resultNumberOfPhotos = (resultAlbum["count"] as? Int) ?? 0

                            let album = FBAlbum(id: resultAlbumId,
                                                name: resultAlbumName,
                                                coverPhotoId: resultCoverPhotoId,
                                                numberOfPhotos: resultNumberOfPhotos)
                            albums.append(album)
                        }
                    }
                }
            }
            callback(albums, nil)
        })
    }
}
