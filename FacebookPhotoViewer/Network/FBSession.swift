//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation
import FBSDKLoginKit

/// A representation of Facebook user session
internal class FBSession {

    /// Returns if user is logged in to Facebook
    static var isLoggedIn: Bool {
        return FBSDKAccessToken.current() != nil
    }
}
