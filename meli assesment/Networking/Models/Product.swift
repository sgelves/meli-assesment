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

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case price
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
