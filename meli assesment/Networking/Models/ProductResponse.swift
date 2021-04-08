//
//  MeliApiResponse.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

struct ProductResponse: Codable {

    var query: String
    var results: [Product]

    enum CodingKeys: String, CodingKey {
        case query
        case results
    }
}
