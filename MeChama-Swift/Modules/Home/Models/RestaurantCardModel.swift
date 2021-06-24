//
//  RestaurantCardModel.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 23/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation

struct RestaurantCardModel: Codable {
    let id: Int
    let name: String
    let description: String
    let LogoImg: String
}
