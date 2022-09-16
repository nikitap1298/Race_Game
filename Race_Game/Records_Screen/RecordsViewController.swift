//
//  RecordsViewController.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 15.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

class RecordsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let dateDict = UserDefaults.standard.object(forKey: K.userDateKey) as? [String: String] {
//            for (key, value) in dateDict {
//                print("User: \(key); Date: \(value)")
//            }
//        }
        viewModel.viewDidLoad()
        bindTableView()
    }
    
    // MARK: - Private Functions
    private func bindTableView() {
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        viewModel.model.bind(to: tableView.rx.items(cellIdentifier: "CustomCell")) { indexPath, title, cell in
            cell.textLabel?.text = "\(title.name) - \(title.score)"
        }
        .disposed(by: disposeBag)
    }
    
}

//extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return keyArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        cell.textLabel?.text = "\(keyArray[indexPath.row]) - \(valueArray[indexPath.row]) points"
//        return cell
//    }
//}
