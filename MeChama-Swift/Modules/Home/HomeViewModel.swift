//
//  HomeViewModel.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 22/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    private let disposeBag = DisposeBag()
    //Criando state do tipo String com valor vazio
    var text = BehaviorRelay<String>(value: "")
    
    var restaurantCard = BehaviorRelay<[RestaurantCardModel]>(value: [])
    
    func fetchResults(){
        RestaurantCardService().fetchResults {(res, error) in
            if let response = res {
                self.restaurantCard.accept(response)
            }
        }
    }
    
    func getText() {
        text.accept("Renato")
    }
}
