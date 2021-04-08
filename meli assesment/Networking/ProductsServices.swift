//
//  ProductsServices.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

class ProductsServices {
    
    static func getSingleProducts(byId id: String, completion: @escaping(Result<Product, ApiError>) -> Void) {
        guard !id.isEmpty else {
            completion(.failure(.invalidParameters))
            return
        }

        Networking(path: "/items/\(id)", method: .get)
            .execute(withCodable: Product.self) { (result) in completion(result) }
    }
    
    static func getProductsList(byQuery query: String, limit: Int, andOffset offset: Int, completion: @escaping(Result<[Product], ApiError>) -> Void) {
        guard limit >= 1 && offset >= 0 else {
            completion(.failure(.invalidParameters))
            return
        }
        
        // Site id MLB is not parametrized on purpose
        Networking(path: "/sites/MLB/search", parameters: ["q": query, "limit": "\(limit)", "offset": "\(offset)"], method: .get)
            .execute(withCodable: ProductResponse.self) { (result) in completion(result.map({$0.results})) }
    }
}
