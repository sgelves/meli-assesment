//
//  ProductDescription.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

struct ProductDescription: Codable {

    var plainText: String

    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}
