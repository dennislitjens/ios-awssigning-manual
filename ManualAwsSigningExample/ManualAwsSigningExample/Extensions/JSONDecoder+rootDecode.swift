//
//  JSONDecoder+rootDecode.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

extension JSONDecoder {

    func decodeData<T: Decodable>(_ type: T.Type, from data: Data, keyedBy key: String?) throws -> T {
        if let key = key {
            userInfo[.jsonDecoderRootKeyName] = key
            let root = try decode(RootResponse<T>.self, from: data)
            return root.value
        } else {
            return try decode(type, from: data)
        }
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyedBy key: String?) throws -> T {
        if let key = key {
            userInfo[.jsonDecoderRootKeyName] = key
            let value = try decode(T.self, from: data)
            return value
        } else {
            return try decode(type, from: data)
        }
    }
}

extension CodingUserInfoKey {
    static let jsonDecoderRootKeyName = CodingUserInfoKey(rawValue: "rootKeyName")!
}
