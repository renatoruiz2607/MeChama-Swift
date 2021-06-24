//
//  MeChamaApiRouter.swift
//  MeChama-Swift
//
//  Created by fleury on 24/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import Alamofire

struct Header {
    var key: String
    var value: String
}

enum MeChamaApiRouter: URLRequestConvertible {
    
    case getRestaurantCard(token: String)
    case postRestaurantCard(token: String, fullName: String, email: String)
    
    func asURLRequest() throws -> URLRequest {
        
        guard let url = URL(string: "http://tn-15mechama-com.umbler.net") else {
            print("Invalid URL")
            return URLRequest(url: URL(fileURLWithPath: ""))
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        var fullPathStr = "http://tn-15mechama-com.umbler.net" + path
        
        if path.contains("http") {
            fullPathStr = path
            urlRequest = URLRequest(url: URL(string: path) ?? url.appendingPathComponent(path))
        }
        
        if let encoded = fullPathStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let auxUrl = URL(string: encoded) {
            urlRequest = URLRequest(url: auxUrl)
        }
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let headers = self.headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        urlRequest.httpBody = data
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getRestaurantCard:
            return "/company/"
        case .postRestaurantCard:
            return "/register"
        }
    }
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .postRestaurantCard:
            return .post
        default:
            return .get
        }
    }
    
    // MARK: - Headers
    private var headers: [Header]? {
        switch self {
        case .getRestaurantCard(let token):
            return [
                Header(key: "tokenUserJWT", value: token)
            ]
        default:
            return nil
        }
    }
    
    // MARK: - Data
    private var data: Data? {
        return nil
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .postRestaurantCard(_, let fullName, let email):
            return [
                "fullName": fullName,
                "email": email
            ]
        default:
            return nil
        }
    }

}
