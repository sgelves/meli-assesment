//
//  ProductsServices.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

protocol ProductsServiceProtocol {

    static func getSingleProducts(byId id: String, completion: @escaping(Result<Product, ApiError>) -> Void)

    static func getProductsList(byQuery query: String,
                                limit: Int,
                                andOffset offset: Int,
                                completion: @escaping(Result<[Product], ApiError>) -> Void)
}

class ProductsServices: ProductsServiceProtocol {

    enum Paths: String {
        case productsList = "/sites/MLB/search"
        case singleProduct = "/items/%@"
    }

    static func getSingleProducts(byId id: String, completion: @escaping(Result<Product, ApiError>) -> Void) {
        guard !id.isEmpty else {
            completion(.failure(.invalidParameters))
            return
        }

        Networking(path: String(format: Paths.singleProduct.rawValue, id) , method: .get)
            .execute(withCodable: Product.self) { (result) in completion(result) }
    }

    static func getProductsList(byQuery query: String,
                                limit: Int,
                                andOffset offset: Int,
                                completion: @escaping(Result<[Product], ApiError>) -> Void) {
        guard !query.isEmpty && limit >= 1 && offset >= 0 else {
            completion(.failure(.invalidParameters))
            return
        }

        // Site id MLB is not parametrized on purpose
        Networking(path: Paths.productsList.rawValue,
                   parameters: ["q": query, "limit": "\(limit)", "offset": "\(offset)"],
                   method: .get)
            .execute(withCodable: ProductResponse.self) { (result) in
                completion(result.map({$0.results}))
            }
    }
}
