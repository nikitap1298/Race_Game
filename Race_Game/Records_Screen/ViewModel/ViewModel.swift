//
//  ViewModel.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 13.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

struct CellModel {
    let name: String
    let score: Int
}

class ViewModel {
    var model = BehaviorRelay<[CellModel]>(value: [])
    
    func viewDidLoad() {
        var model = [CellModel]()
        
        if let userDictionary = UserDefaults.standard.object(forKey: K.userDefaultsKey) as? [String: Int] {
            for (key, value) in userDictionary {
                print("User: \(key); Score: \(value)")
                model.append(.init(name: key, score: value))
            }
        }
        self.model.accept(model)
    }
}
