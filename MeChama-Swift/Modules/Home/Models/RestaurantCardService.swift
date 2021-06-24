//
//  RestaurantCardService.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 23/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RestaurantCardService {
    public typealias RestaurantCardResult = ApiResult<RestaurantCardModel>
    
    func fetchResults(token: String) -> Observable<RestaurantCardResult> {

        return Observable<RestaurantCardResult>.create { observer in

            MeChamaApiClient().getRestaurantCard(token: token) { result in

                observer.onNext(result)
                observer.onCompleted()

            }
            return Disposables.create()
        }
    }
}

