//
//  APIRequestRetrier.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import Alamofire

/// Implements simple retry logic for API requests.
struct APIRequestRetrier: RequestRetrier {
    let numberOfRetries: UInt = 1
    let retryDelay: TimeInterval = 2.0
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        func retry() {
            completion(true, retryDelay)
        }
        
        func dontRetry() {
            completion(false, 0)
        }
        
        guard request.retryCount < numberOfRetries else {
            dontRetry()
            return
        }
        guard let response = request.response else {
            request.request?.httpMethod == HTTPMethod.get.rawValue ? retry() : dontRetry()
            return
        }
        switch response.statusCode {
        case 500...599:
            retry()
        default:
            dontRetry()
        }
    }
}
