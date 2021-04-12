//
//  ShippingMethod.swift
//  meli assesment
//
//  Created by Sergio Gelves on 12/04/21.
//

struct ShippingMethod: Codable {
    var freeShipping: Bool

    enum CodingKeys: String, CodingKey {
        case freeShipping = "free_shipping"
    }
}
