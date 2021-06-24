//
//  MeChamaApiClient.swift
//  MeChama-Swift
//
//  Created by fleury on 24/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class MeChamaApiClient: ApiClient {

    // MARK: Get Info
    func getRestaurantCard(token: String, completion: @escaping (ApiResult<RestaurantCardModel>) -> Void) {

        self.request(useRetrier: false, MeChamaApiRouter.getRestaurantCard(token: token)) { (result) in
            switch result {
            case let .success(data):
                do {
                    let item = try JSONDecoder().decode(RestaurantCardModel.self, from: data)
                    completion(.success(item))
                } catch let error {
                    print(error)
                    completion(.failure(.parse(codeError: 0)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
