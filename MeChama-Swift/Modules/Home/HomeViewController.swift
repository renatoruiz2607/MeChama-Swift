//
//  HomeViewController.swift
//  MeChama-Swift
//
//  Created by Roberto Ruiz Cai on 22/06/21.
//  Copyright © 2021 Renato Ruiz. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    var viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var textLabel: UILabel!
    init() {
        viewModel = HomeViewModel()
        super.init(nibName: "HomeViewController", bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        viewModel.text
            .observe(on: MainScheduler.asyncInstance).skip(1)
            .subscribe(onNext: { [weak self] text in
                self?.textLabel.text = text
            }).disposed(by: disposeBag)
        
        viewModel.restaurantCard
        .observe(on: MainScheduler.asyncInstance).skip(1)
        .subscribe(onNext: { [weak self] restaurantCard in
            print(restaurantCard)
        }).disposed(by: disposeBag)
        
        viewModel.getText()
        viewModel.fetchResults()
    }
}
