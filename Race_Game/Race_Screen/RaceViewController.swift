//
//  RaceViewController.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 15.06.2022.
//

import UIKit

class RaceViewController: UIViewController {
    
    // MARK: - Private Properties
    private let hapticFeedback = UINotificationFeedbackGenerator()
    private let roadWidth: CGFloat = 200
    private var trueOrFalse: Bool = true
    private var score: Int = 0
    
    private var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .white
        scoreLabel.backgroundColor = UIColor(named: "colorRoad")
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        return scoreLabel
    }()
    
    private var road: UIView = {
        let road = UIView()
        road.backgroundColor = UIColor(named: "colorRoad")
        road.translatesAutoresizingMaskIntoConstraints = false
        return road
    }()
    
    private  var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.backgroundColor = UIColor(named: "colorYellow")
        leftButton.setTitle("<-", for: .normal)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        return leftButton
    }()
    
    private  var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.backgroundColor = UIColor(named: "colorYellow")
        rightButton.setTitle("->", for: .normal)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        return rightButton
    }()
    
    private var whiteLine: UIView = {
        let whiteLine = UIView()
        whiteLine.backgroundColor = .white
        whiteLine.translatesAutoresizingMaskIntoConstraints = false
        return whiteLine
    }()
    
    private var car: UIImageView = {
        let car = UIImageView()
        car.image = UIImage(named: "Car_Image")
        let color = UserDefaults.standard.value(forKey: K.car) as? String
        switch color {
        case "Yellow":
            AllSettings.singleton.carColor = .systemYellow
        case "Red":
            AllSettings.singleton.carColor = .systemRed
        case "Blue":
            AllSettings.singleton.carColor = .systemBlue
        default:
            break
        }
        car.tintColor = AllSettings.singleton.carColor
        car.contentMode = .scaleAspectFit
        car.translatesAutoresizingMaskIntoConstraints = false
        return car
    }()
    
    private var stone: UIImageView = {
        let stone = UIImageView()
        let barrierImage = UserDefaults.standard.value(forKey: K.barrier) as? String
        switch barrierImage {
        case "Grass":
            AllSettings.singleton.barrier = UIImage(named: "Grass_Image")!
        case "Barrier":
            AllSettings.singleton.barrier = UIImage(named: "Barrier_Image")!
        default:
            break
        }
        stone.image = AllSettings.singleton.barrier
        stone.contentMode = .scaleToFill
        stone.translatesAutoresizingMaskIntoConstraints = false
        return stone
    }()
    
    private var carTopAnchor: NSLayoutConstraint?
    private var carLeadingAnchor: NSLayoutConstraint?
    private var carTrailingAnchor: NSLayoutConstraint?
    
    private var stoneTopAnchor: NSLayoutConstraint?
    private var stoneCenterX: NSLayoutConstraint?
    private var stoneBottomAnchor: NSLayoutConstraint?
    
    private var timer: Timer?
    
    // MARK: - Public Properties
    
    // Helps to transfer data on OnboardingViewController
    var resultCompletion: ((Int) -> ())?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoad()
        setupScoreLabel()
        setupLeftButton()
        setupRightButton()
        setupWhiteLine()
        setupCar()
        setupStone()
        createVerticalTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leftButton.addCornerRadius()
        rightButton.addCornerRadius()
        scoreLabel.layer.masksToBounds = true
        scoreLabel.addCornerRadius()
    }
    
    deinit {
        timer?.invalidate()
        
        // Add new value to the existing values in the dictionary
        // Dictionary[Name] = Score
        var dictionary = UserDefaults.standard.object(forKey: K.userDefaultsKey) as? [String: Int] ?? [:]
        dictionary[User.singleton.userName] = score
        UserDefaults.standard.set(dictionary, forKey: K.userDefaultsKey)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy, h:mm:ss a"
        let dateString = dateFormatter.string(from: Date())
        print(dateString)
        
        // Add new date to the existing value in the dateDictionary
        // Dictionary[Name] = DateString
        var dateDictionary = UserDefaults.standard.object(forKey: K.userDateKey) as? [String: String] ?? [:]
        dateDictionary[User.singleton.userName] = dateString
        UserDefaults.standard.set(dateDictionary, forKey: K.userDateKey)
    }
    
    // MARK: - Actions
    @objc private func tapLeftButton() {
        hapticFeedback.notificationOccurred(.success)
        guard let carLeadingAnchor = carLeadingAnchor,
              let carTrailingAnchor = carTrailingAnchor else {
            return
        }
        carLeadingAnchor.constant -= 20
        carTrailingAnchor.constant -= 20
        if carLeadingAnchor.constant <= -25 {
            self.resultCompletion?(self.score)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func tapRightButton() {
        hapticFeedback.notificationOccurred(.success)
        guard let carLeadingAnchor = carLeadingAnchor,
              let carTrailingAnchor = carTrailingAnchor else {
            return
        }
        carLeadingAnchor.constant += 20
        carTrailingAnchor.constant += 20
        if carTrailingAnchor.constant >= 25 {
            self.resultCompletion?(self.score)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Private Functions
    
    // road constraints
    private func setupRoad() {
        view.addSubview(road)
        
        NSLayoutConstraint.activate([
            road.topAnchor.constraint(equalTo: view.topAnchor),
            road.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            road.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            road.widthAnchor.constraint(equalToConstant: roadWidth)
        ])
    }
    
    // scoreLabel constraints
    private func setupScoreLabel() {
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scoreLabel.leadingAnchor.constraint(equalTo: road.trailingAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // leftButton constraints
    private func setupLeftButton() {
        view.addSubview(leftButton)
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            leftButton.trailingAnchor.constraint(equalTo: road.leadingAnchor, constant: -15),
            leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            leftButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
    }
    
    // rightButton constraints
    private func setupRightButton() {
        view.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            rightButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            rightButton.leadingAnchor.constraint(equalTo: road.trailingAnchor, constant: 15),
            rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            rightButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
    }
    
    // whiteLine constraints
    private func setupWhiteLine() {
        road.addSubview(whiteLine)
        
        NSLayoutConstraint.activate([
            whiteLine.centerXAnchor.constraint(equalTo: road.centerXAnchor),
            whiteLine.topAnchor.constraint(equalTo: road.topAnchor, constant: 0),
            whiteLine.bottomAnchor.constraint(equalTo: road.bottomAnchor, constant: 0),
            whiteLine.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    // car constraints
    private func setupCar() {
        road.addSubview(car)
        
        carTopAnchor = car.topAnchor.constraint(equalTo: road.topAnchor, constant: 500)
        carLeadingAnchor = car.leadingAnchor.constraint(equalTo: road.leadingAnchor, constant: roadWidth / 3)
        carTrailingAnchor = car.trailingAnchor.constraint(equalTo: road.trailingAnchor, constant: -roadWidth / 3)
        
        NSLayoutConstraint.activate([
            car.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        guard let carTopAnchor = carTopAnchor,
              let carLeadingAnchor = carLeadingAnchor,
              let carTrailingAnchor = carTrailingAnchor else {
            return
        }
        carTopAnchor.isActive = true
        carLeadingAnchor.isActive = true
        carTrailingAnchor.isActive = true
    }
    
    // stone constraints
    private func setupStone() {
        road.addSubview(stone)
        
        stoneTopAnchor = stone.topAnchor.constraint(equalTo: road.topAnchor, constant: -100)
        stoneCenterX = stone.centerXAnchor.constraint(equalTo: road.centerXAnchor, constant: -roadWidth / 4)
        stoneBottomAnchor = stone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        
        NSLayoutConstraint.activate([
            stone.widthAnchor.constraint(equalToConstant: 50),
            stone.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        guard let stoneTopAnchor = stoneTopAnchor,
              let stoneCenterX = stoneCenterX,
              let stoneBottomAnchor = stoneBottomAnchor else {
            return
        }
        stoneTopAnchor.isActive = true
        stoneCenterX.isActive = true
        stoneBottomAnchor.isActive = false
    }
    
    private func createVerticalTimer() {
        let speed = UserDefaults.standard.value(forKey: K.speed) as? Double
        switch speed {
        case 2.5:
            AllSettings.singleton.speed = 2.5
        case 3.5:
            AllSettings.singleton.speed = 3.5
        default:
            break
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: AllSettings.singleton.speed, repeats: true) { [weak self] (timer) in
            self?.animateBottom()
            self?.positionStone()
            self?.score += 1
            self?.scoreLabel.text = String(self?.score ?? 0)
        }
    }
    
    private func animateBottom() {
        trueOrFalse = Bool.random()
        guard let stoneTopAnchor = stoneTopAnchor,
              let stoneBottomAnchor = stoneBottomAnchor else {
            return
        }
        stoneTopAnchor.isActive = false
        stoneBottomAnchor.isActive = true
        UIView.animate(withDuration: AllSettings.singleton.speed, delay: 0.0, options: .repeat) {
            self.road.layoutIfNeeded()
        } completion: { _ in
            self.stoneCenterX?.constant = self.trueOrFalse ? -self.roadWidth / 4 : self.roadWidth / 4
        }
    }
    
    private func positionStone() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] (timer) in
            
            // Check for overlapping images
            if let pointStone = self?.stone.layer.presentation()?.frame.intersects(self?.car.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)) {
                if pointStone == true {
                    self?.resultCompletion?(self?.score ?? 0)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
}
