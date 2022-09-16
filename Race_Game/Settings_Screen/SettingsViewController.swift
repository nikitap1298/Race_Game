//
//  SettingsViewController.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 15.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var buttonsLabel: [UIButton]!
    @IBOutlet weak var carColorButtonLabel: UIButton!
    @IBOutlet weak var barrierButtonLabel: UIButton!
    @IBOutlet weak var speedButtonLabel: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "colorYellow")
        
        carColorButtonLabel.setTitle(L10n.carColorButtonLabel, for: .normal)
        barrierButtonLabel.setTitle(L10n.barrierButtonLabel, for: .normal)
        speedButtonLabel.setTitle(L10n.speedButtonLabel, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for i in buttonsLabel {
            i.layer.cornerRadius = 30
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func carColorButton(_ sender: UIButton) {
        colorAlert()
    }
    
    @IBAction func barrierButton(_ sender: UIButton) {
        barrierAlert()
    }
    
    @IBAction func speedButton(_ sender: UIButton) {
        speedAlert()
    }
    
    // MARK: - Private Functions
    private func colorAlert() {
        let alert = UIAlertController(title: nil, message: L10n.carColorButtonAlertMessage, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: L10n.defaultWord, style: .default) { action in
            UserDefaults.standard.set("Yellow", forKey: K.car)
        }
        let secondAction = UIAlertAction(title: L10n.carColorButtonAlertSecondAction, style: .default) { action in
            UserDefaults.standard.set("Red", forKey: K.car)
        }
        let thirdAction = UIAlertAction(title: L10n.carColorButtonAlertThirdAction, style: .default) { action in
            UserDefaults.standard.set("Blue", forKey: K.car)
        }
        let fourthAction = UIAlertAction(title: L10n.alertCancel, style: .cancel)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.addAction(fourthAction)
        present(alert, animated: true)
    }
    
    private func barrierAlert() {
        let alert = UIAlertController(title: nil, message: L10n.barrierButtonAlertMessage, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title:  L10n.defaultWord, style: .default) { action in
            UserDefaults.standard.set("Grass", forKey: K.barrier)
        }
        let secondAction = UIAlertAction(title: L10n.barrierButtonAlertSecondAction, style: .default) { action in
            UserDefaults.standard.set("Barrier", forKey: K.barrier)
        }
        let thirdAction = UIAlertAction(title: L10n.alertCancel, style: .cancel)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        present(alert, animated: true)
    }
    
    private func speedAlert() {
        let alert = UIAlertController(title: nil, message: L10n.speedButtonAlertMessage, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title:  L10n.defaultWord, style: .default) { action in
            UserDefaults.standard.set(2.5, forKey: K.speed)
        }
        let secondAction = UIAlertAction(title: L10n.speedButtonAlertSecondAction, style: .default) { action in
            UserDefaults.standard.set(3.5, forKey: K.speed)
        }
        let thirdAction = UIAlertAction(title: L10n.alertCancel, style: .cancel)
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        present(alert, animated: true)
    }
    
}

