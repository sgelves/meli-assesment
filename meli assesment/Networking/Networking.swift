//
//  Networking.swift
//  meli assesment
//
//  Created by Sergio Gelves on 7/04/21.
//

import Alamofire

enum ApiError: Error {
    case connectionError
    case invalidRequest
    case invalidRequestMethod
    case jsonParseError
    case invalidParameters
    case serverError
    case requestAuthError
}

class Networking {

    var path: String
    var method: HTTPMethod
    var parameters: [String: String]
    var domain: Domain
    
    init(path: String, parameters: [String: String] = [:], method: HTTPMethod = .get, domain: Domain = .develop) {
        self.path = path
        self.parameters = parameters
        self.method = method
        self.domain = domain
    }
    
    enum Domain: String {
        case develop = "https://api.mercadolibre.com"
    }
    
    func execute<T: Codable>(withCodable codable: T.Type, completion: @escaping(Result<T, ApiError>) -> Void) {
        guard self.method == .get else {
            completion(.failure(.invalidRequestMethod))
            return
        }
        
        let urlString = "\(domain.rawValue)\(self.path)"

        AF.request(urlString, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: codable) { response in
                
                switch response.result {
                
                case .success:
                    if let decoded = response.value {
                        
                        completion(.success(decoded))
                    } else {
                        
                        completion(.failure(.jsonParseError))
                        
                        #if DEBUG
                        LogUtils.debug(withMessage: "\(ApiError.jsonParseError)", andData: response.value)
                        #else
                        LogUtils.error(ApiError.jsonParseError, withData: response.value)
                        #endif
                    }
                    
                case .failure:
                    
                    var error: ApiError
                    if let statusCode = response.response?.statusCode {
                        
                        switch statusCode {
                        case 500..<520:
                            error = .serverError
                        case 401:
                            error = .requestAuthError
                        default:
                            error = .invalidRequest
                        }
                    } else {
                        error = .connectionError
                    }
                    
                    completion(.failure(error))
                    
                    #if DEBUG
                    LogUtils.debug(withMessage: "\(error)", andData: response.value)
                    #else
                    LogUtils.error(error, withData: response.value)
                    #endif
                }
            }
    }
}

