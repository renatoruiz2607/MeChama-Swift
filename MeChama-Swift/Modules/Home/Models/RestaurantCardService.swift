//
//  RestaurantCardService.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 23/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import Foundation
import Alamofire

typealias completion <T> = (_ result: T, _ failure: Bool) -> Void

class RestaurantCardService {
    func fetchResults(completion: @escaping completion<[RestaurantCardModel]?>) {
        let headers: HTTPHeaders = [
            "tokenUserJWT": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJib2JzQGdtYWlsLmNvbSIsIm5hbWUiOiJCb2JzIiwibnVtYmVyIjpudWxsLCJUeXBlIjoiZW1wcmVzYSIsImVtcHJlc2EiOnsiYmFubmVyIjoiQk9CU19MT0dPLmpwZyIsImxvZ28iOiIyNTZ4MjU2YmIuanBnIiwibmFtZSI6IkJvYidzIn0sImlhdCI6MTYyNDU1MTQwNX0.w2TZWrUR2W94QmaOp-E2nINGWY7C_WEz0lfUgyuoDZk"
        ]
        Alamofire.request("http://tn-15mechama-com.umbler.net/company/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {res in
            switch res.result {
            case .success(let data):
                print(data)
                do {
                    let jsonData = try JSONEncoder().encode(data)
                    let decodedList = try JSONDecoder().decode([RestaurantCardModel].self, from: jsonData)
                    completion(decodedList, false)
                } catch {
                    completion(nil,true)
                }
                
            default:
                break
            }
        }
    }
}

