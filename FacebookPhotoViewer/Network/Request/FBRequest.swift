//
//  Copyright © 2017 user16331. All rights reserved.
//

import Foundation

/// A protocol describing abstract request to Facebook API
internal protocol FBRequest {

    /// Type of request successfull result
    associatedtype Result

    /// Execute request
    func execute(_ callback: @escaping (Result, FBRequestError?) -> Void);
}
