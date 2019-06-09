//
//  SessionManager+Observable.swift
//  PareshMasaniCV
//
//  Created by Paresh Masani on 09/06/2019.
//  Copyright © 2019 paresh. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

/// Contains original response data and decoded model.
struct DecodableResponse<Model: Decodable> {
    let data: Data
    let model: Model
}

extension SessionManager {
    // generic method which can be used in future for any GET request
    func makeObservable<Model: Decodable>(withURL url: URLConvertible, jsonDecoder: JSONDecoder) -> Observable<DecodableResponse<Model>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.request(url).responseData { response in
                switch response.result {
                case .failure(let error):
                    observer.onError(error)
                case .success(let data):
                    // try to decode the model
                    do {
                        let model = try jsonDecoder.decode(Model.self, from: data)
                        observer.onNext(DecodableResponse(data: data, model: model))
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
