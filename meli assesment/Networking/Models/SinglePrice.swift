//
//  Price.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

struct SinglePrice: Codable {
    var id: String
    var type: String
    var amount: Float
    var regularAmount: Float?

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case amount
        case regularAmount = "regular_amount"
    }
}
