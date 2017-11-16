//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation

/// An album with photos on Facebook
internal struct FBAlbum {

    /// Identifier
    let id: String

    /// Name
    let name: String?

    /// Identifier of the cover photo
    let coverPhotoId: String?

    /// Number of photos
    let numberOfPhotos: Int
}
