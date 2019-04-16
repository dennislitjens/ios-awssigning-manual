//
//  LocationEntry.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

struct LocationEntry {
    let name: String
    let identifier: String
    let latitude: Double
    let longitude: Double
    let radius: Double
}

extension LocationEntry: Decodable {
    private enum LocationEntryCodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case latitude
        case longitude
        case radius
    }

    enum DataKey: String, CodingKey {
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationEntryCodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.radius = try container.decode(Double.self, forKey: .radius)

        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
