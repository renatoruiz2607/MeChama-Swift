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
    //Criando state do tipo Welcome com valor vazio
    var restaurantCard = BehaviorRelay<RestaurantCardModel?>(value: nil)
    
    func fetchResults() {
        RestaurantCardService().fetchResults(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJib2JzQGdtYWlsLmNvbSIsIm5hbWUiOiJCb2JzIiwibnVtYmVyIjpudWxsLCJUeXBlIjoiZW1wcmVzYSIsImVtcHJlc2EiOnsiYmFubmVyIjoiQk9CU19MT0dPLmpwZyIsImxvZ28iOiIyNTZ4MjU2YmIuanBnIiwibmFtZSI6IkJvYidzIn0sImlhdCI6MTYyNDU1MTQwNX0.w2TZWrUR2W94QmaOp-E2nINGWY7C_WEz0lfUgyuoDZk")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [self] result in
                switch result {
                case .success(let info):
                    restaurantCard.accept(info)
                case .failure:
                    debugPrint("get failed")
                }
            }).disposed(by: disposeBag)
    }
}
