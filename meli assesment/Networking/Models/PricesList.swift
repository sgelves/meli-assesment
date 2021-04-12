//
//  Prices.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

struct PricesList: Codable {

    var id: String?
    var prices: [SinglePrice]?

    enum CodingKeys: String, CodingKey {
        case id
        case prices
    }
}
