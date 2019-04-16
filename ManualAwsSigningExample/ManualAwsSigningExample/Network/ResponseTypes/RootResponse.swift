//
//  RootResponse.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

struct RootResponse<T>: Decodable where T: Decodable {

    private struct CodingKeys: CodingKey {

        var stringValue: String
        var intValue: Int?

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        static func key(named name: String) -> CodingKeys? {
            return CodingKeys(stringValue: name)
        }
    }

    let value: T

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let keyName = decoder.userInfo[.jsonDecoderRootKeyName] as? String,
            let key = CodingKeys.key(named: keyName) else {
                throw DecodingError.valueNotFound(
                    T.self, DecodingError.Context(codingPath: [], debugDescription: "Value not found at root level.")
                )
        }

        value = try container.decode(T.self, forKey: key)
    }
}
