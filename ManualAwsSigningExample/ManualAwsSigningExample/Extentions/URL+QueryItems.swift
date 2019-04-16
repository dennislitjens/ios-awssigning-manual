//
//  URL+QueryItems.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit

extension URL {

    @discardableResult
    func append(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        guard let value = value else { return absoluteURL }
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
