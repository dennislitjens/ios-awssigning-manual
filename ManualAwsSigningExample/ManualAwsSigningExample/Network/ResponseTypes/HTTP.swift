//
//  HTTP.swift
//  DocFoundry
//
//  Created by Dennis Litjens on 11/03/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Alamofire

enum HTTP {
    enum ContentType {
        case urlEncoded
        case json

        var httpHeaderValue: String? {
            switch self {
            case .urlEncoded: return "application/x-www-form-urlencoded"
            case .json: return "application/json"
            }
        }
    }

    typealias Headers = [String: String]

    struct HeaderKey: RawRepresentable, ExpressibleByStringLiteral {
        static let authorization: HeaderKey = "Authorization"
        static let acceptLanguage: HeaderKey = "Accept-Language"
        static let xClientInfo: HeaderKey = "X-client-info"
        static let ngAccessToken: HeaderKey = "access_token"

        let rawValue: String

        init(rawValue value: String) {
            self.rawValue = value
        }

        init(stringLiteral value: String) {
            self.rawValue = value
        }
    }

    struct Method: RawRepresentable {

        static let get = Method(rawValue: "GET")
        static let post = Method(rawValue: "POST")
        static let put = Method(rawValue: "PUT")

        let rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    struct JSONEncodingError: Error { }

    struct Body {

        let data: Data
        let contentType: ContentType

        init(data: Data, contentType: ContentType = .urlEncoded) {
            self.data = data
            self.contentType = contentType
        }

        init(urlEncoded parameters: [(String, Any)]) {
            self.contentType = .urlEncoded
            let encoding = URLEncoding()

            self.data = parameters.map { key, value in
                let valueStringParsed = String(describing: value)
                let valueStringEncoded = encoding.escape(valueStringParsed)
                return "\(key)=\(valueStringEncoded)"
                }.joined(separator: "&").data(using: .utf8) ?? Data()
        }

        init(json parameters: [String: Any]) throws {
            self.contentType = .json
            do {
                self.data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw JSONEncodingError()
            }
        }
    }
}
