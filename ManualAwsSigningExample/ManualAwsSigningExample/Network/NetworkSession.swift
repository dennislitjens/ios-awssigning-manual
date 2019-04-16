//
//  NetworkSession.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Alamofire
import RxSwift

protocol NetworkSession {
    func perform(request: URLRequest) throws -> Single<NetworkResponse>
}

extension SessionManager: NetworkSession {
    func perform(request: URLRequest) throws -> Single<NetworkResponse> {
        return Single.create { single -> Disposable in
            self.request(request)
                .validate()
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(NetworkManagerResponse(
                            response: response.response,
                            data: data
                        )))
                    case .failure(let error):
                        single(.error(NetworkManagerResponseError(
                            response: response.response,
                            data: response.data ?? Data(),
                            networkError: error
                        )))
                    }
                })

            return Disposables.create()
        }
    }
}

