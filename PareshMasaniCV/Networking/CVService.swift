//
//  CVService.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

/// Defines interface for CV Service.
protocol CVServiceProtocol {
    func getCV() -> Observable<DecodableResponse<CVModel>>
}

/// Responsible for retrieving the CV from server.
struct CVService: CVServiceProtocol {
    
    private enum Const {
        static let cvURL = "https://gist.githubusercontent.com/masaniparesh/891fa3be29a4f3661ba7987c87cab3c0/raw/mycv-json"
    }
    
    private let sessionManager: SessionManager
    
    private static func makeDefaultSessionManager() -> SessionManager {
        let sessionManager = SessionManager()
        sessionManager.retrier = APIRequestRetrier()
        return sessionManager
    }
    
    /// Dependency injection allows us to mock the session manager in tests.
    init(sessionManager: SessionManager = CVService.makeDefaultSessionManager()) {
        self.sessionManager = sessionManager
    }
    
    func getCV() -> Observable<DecodableResponse<CVModel>> {
        return sessionManager.makeObservable(withURL: Const.cvURL, jsonDecoder: .default)
    }
    
}
