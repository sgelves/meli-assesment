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
    case methodNotAllowed
    case jsonParseError
    case invalidParameters
    case serverError
    case alamofireError
}

class Networking {

    var path: String
    var method: HTTPMethod
    var parameters: [String: String]
    var domain: Domain

    static var sessionManager = Session()

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
            completion(.failure(.methodNotAllowed))
            return
        }

        let urlString = "\(domain.rawValue)\(self.path)"

        Networking.sessionManager
            .request(urlString, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: codable) { response in

                switch response.result {

                case .success:
                    if let decoded = response.value {

                        completion(.success(decoded))
                    } else {

                        completion(.failure(.alamofireError))
                        LogUtils.error(ApiError.alamofireError, withData: response.value)
                    }

                case .failure:

                    var error: ApiError
                    let statusCode = response.response?.statusCode ?? 0

                    switch statusCode {
                    case 500..<520:
                        error = .serverError
                    case 400..<500:
                        error = .invalidRequest
                    case 200..<300:
                        error = .jsonParseError
                    default:
                        error = .connectionError
                    }

                    completion(.failure(error))

                    #if DEBUG
                    LogUtils.debug(withMessage: "\(error)", andData: response.result)
                    #else
                    LogUtils.error(error, withData: response.result)
                    #endif
                }
            }
    }
}
