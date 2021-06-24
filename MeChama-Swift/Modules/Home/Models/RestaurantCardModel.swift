//
//  RestaurantCardModel.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 23/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct RestaurantCardModel: Codable {
    let mansageError: Bool
    let products: [Product]
    let empresa: Empresa
    let user: User
}

// MARK: - Empresa
struct Empresa: Codable {
    let banner, logo, name: String
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let name, productDescription: String
    let value: Int
    let img: String
    let additionals: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case productDescription = "description"
        case value, img, additionals
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let email, name: String
    let number: JSONNull?
    let type: String
    let empresa: Empresa
    let iat: Int

    enum CodingKeys: String, CodingKey {
        case id, email, name, number
        case type = "Type"
        case empresa, iat
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
