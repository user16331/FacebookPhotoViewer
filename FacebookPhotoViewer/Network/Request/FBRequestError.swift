//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation

/// Facebook API Request Error
internal enum FBRequestError : Error {

    /// User is not logged in
    case notLoggedIn

    /// General error
    case general

    /// Facebook SDK error
    case sdk(Error)

    /// Received zero bytes
    case zeroBinaryData

    /// Failed to create image from bytes
    case invalidImageData
}
