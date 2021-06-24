//
//  ApiClient.swift
//  MeChama-Swift
//
//  Created by fleury on 24/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - Enum to return the request result or error
public enum ApiResult<T>: Equatable {
    case success(T)
    case failure(ApiError)

    public static func == (lhs: ApiResult, rhs: ApiResult) -> Bool {
        switch (lhs, rhs) {
        case (.failure, .failure), (.success, .success):
            return true

        default:
            return false
        }
    }
}

//MARK: - Errors Mapped
public enum ApiError: Error, Equatable {
    case forbidden(codeError: Int) //Status code 403
    case notFound(codeError: Int) //Status code 404
    case conflict(codeError: Int) //Status code 409
    case internalServerError(codeError: Int) //Status code 500
    case empty(codeError: Int) //no data
    case generic(codeError: Int) //generic error
    case parse(codeError: Int) //parse error
    case unauthorized(codeError: Int) //401
    case noInternetConnection(codeError: Int)
    case noContent(codeError: Int) //204
    case preCondition(codeError: Int) //412
    case customized(msgError: String, codeError: Int)

    public var errorMsg: String {
        switch self {
        case .forbidden:
            return "Acesso Negado"
        case .notFound:
            return "Não encontrado"
        case .conflict:
            return "Conflito"
        case .internalServerError:
            return "Ocorreu um erro no servidor"
        case .empty:
            return "Nenhum resultado"
        case .generic:
            return "Ocorreu um erro"
        case .parse:
            return "Não foi possível opter o dado"
        case .unauthorized:
            return "Não autorizado"
        case .customized(let msgError, _):
            return msgError
        case .noInternetConnection:
            return "Sem conexão"
        case .noContent:
            return "Nenhum conteúdo"
        case .preCondition:
            return "Condições incorretas"
        }
    }

    public var errorCode: Int {
        switch self {
        case .forbidden(let codeError):
            return codeError
        case .notFound(let codeError):
            return codeError
        case .conflict(let codeError):
            return codeError
        case .internalServerError(let codeError):
            return codeError
        case .empty(let codeError):
            return codeError
        case .generic(let codeError):
            return codeError
        case .parse(let codeError):
            return codeError
        case .unauthorized(let codeError):
            return codeError
        case .customized(_ , let codeError):
            return codeError
        case .noInternetConnection(let codeError):
            return codeError
        case .noContent(let codeError):
            return codeError
        case .preCondition(let codeError):
            return codeError
        }
    }
}

open class ApiClient {

    public lazy var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(
            configuration: configuration
        )
        return manager
    }()

    public lazy var sessionManagerCode: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(
            configuration: configuration
        )
        return manager
    }()

    public lazy var sessionManagerToken: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let manager = Alamofire.SessionManager(
            configuration: configuration
        )
        return manager
    }()

    public init() {
    }

    //MARK: Check if has access token for request
    public func request(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {

        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }

        self.apiRequest(useRetrier: useRetrier, urlConvertible) { (result) in
            completion(result)
        }
    }

    private func handleResponse(_ response: DataResponse<Data>,
                                _ completion: @escaping (ApiResult<Data>) -> Void) {
        #if DEBUG
        self.debugPrint(dataResponse: response)
        #endif

        guard let statusCode = response.response?.statusCode else {
            return completion(.failure(.generic(codeError: response.response?.statusCode ?? 0)))
        }

        switch response.result {
        case .success:

            if statusCode == 204 {
                completion(.failure(.noContent(codeError: statusCode)))
            }

            if statusCode >= 400 {
                fallthrough
            }

            if let data = response.data {
                completion(.success(data))
                break
            } else {
                completion(.failure(.empty(codeError: statusCode)))
                break
            }

        case .failure:
            switch statusCode {
            case 403:
                completion(.failure(.forbidden(codeError: statusCode)))
            case 404:
                completion(.failure(.notFound(codeError: statusCode)))
            case 409:
                completion(.failure(.conflict(codeError: statusCode)))
            case 500:
                completion(.failure(.internalServerError(codeError: statusCode)))
            case 401:
                completion(.failure(.unauthorized(codeError: statusCode)))
            case 412:
                completion(.failure(.preCondition(codeError: statusCode)))
            default:
                if NetworkReachabilityManager()?.isReachable ?? false {
                    completion(.failure(.generic(codeError: statusCode)))
                } else {
                    completion(.failure(.noInternetConnection(codeError: statusCode)))
                }
            }
        }
    }

    func debugPrint(dataResponse: DataResponse<Data>) {
        guard let response = dataResponse.response else {
            print("Invalid response")
            return
        }

        print("----------------------- RESPONSE ------------------------------")
        print("Request \(response.url?.absoluteString ?? "-no url-") completed with status code \(response.statusCode)")
        print("headers:")
        response.allHeaderFields.forEach() { (key,value) in
            print("\(key) = \(value)")
        }

        if let data = dataResponse.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data:")
            print("\(utf8Text)")
        }

        print("---------------------------------------------------------------")

        guard let request = dataResponse.request else {
            print("Invalid request")
            return
        }
        print("----------------------- RESQUEST ------------------------------")
        print("Request \(request.url?.absoluteString ?? "-no url-") completed with status code \(response.statusCode)")
        print("Method: \(request.httpMethod ?? "?")")
        print("headers:")
        request.allHTTPHeaderFields?.forEach() { (key,value) in
            print("\(key) = \(value)")
        }
        if let data = request.httpBody, let utf8Text = String(data: data, encoding: .utf8) {
            print("Body:")
            print("\(utf8Text)")
        }
    }
    
    //MARK: The request
    private func apiRequest(useRetrier: Bool, _ urlConvertible: URLRequestConvertible, completion: @escaping (ApiResult<Data>) -> Void) {

        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            completion(.failure(.noInternetConnection(codeError: 999)))
        }

        let request = self.sessionManager.request(urlConvertible)
        print("----------------------- cURL ------------------------------")
        Swift.debugPrint(request)
        request.validate().responseData { response in
            self.handleResponse(response, completion)
        }
    }
}
