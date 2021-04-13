//
//  ProductsServicesMock.swift
//  meli assesmentTests
//
//  Created by Sergio Gelves on 10/04/21.
//

@testable import meli_assesment

class ProductsServicesMock: ProductsServiceProtocol {

    static var producListResultAmount: Int = 2

    static func getMockedResult(_ amount: Int) -> [Product] {
        return (0..<amount).map { index -> Product in
            Product(id: "\(index)", title: "", thumbnail: "", price: 0.0, shipping: ShippingMethod(freeShipping: true))
        }
    }

    static func getSingleProducts(byId id: String, completion: @escaping (Result<Product, ApiError>) -> Void) {

    }


    static func getProductsList(byQuery query: String,
                                limit: Int,
                                andOffset offset: Int,
                                completion: @escaping(Result<[Product], ApiError>) -> Void) {

        switch producListResultAmount {

        case -1:
            completion(.failure(ApiError.serverError))

        case 0:
            completion(.success([]))

        default:
            completion(.success(ProductsServicesMock.getMockedResult(producListResultAmount)))
        }
    }

    static func getProductDescription(byId id: String,
                                     completion: @escaping (Result<ProductDescription, ApiError>) -> Void) {
        completion(.success(ProductDescription(plainText: " ")))
    }
}
