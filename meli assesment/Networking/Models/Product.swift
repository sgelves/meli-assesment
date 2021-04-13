//
//  Product.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

struct Product: Codable, CustomStringConvertible {

    var id: String
    var title: String
    var thumbnail: String
    var price: Float
    var prices: PricesList?
    var shipping: ShippingMethod

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case price
        case prices
        case shipping
    }

    // protocol
    var description: String {
        return #"""
            Product {
                id: \#(id),
                title: \#(title),
                price: \#(price),
                price: \#(thumbnail)
            }
            """#
    }
}
