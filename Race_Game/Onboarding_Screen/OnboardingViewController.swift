//
//  ViewController.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 15.06.2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Private Properties
    private var burgerButton: UIButton = {
        let burgerButton = UIButton()
        burgerButton.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
        burgerButton.tintColor = .white
        burgerButton.translatesAutoresizingMaskIntoConstraints = false
        return burgerButton
    }()
    
    private var menuView: UIView = {
        let menuView = UIView()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        return menuView
    }()
    
    private var menuViewTopAnchor: NSLayoutConstraint?
    private var menuViewLeadingAnchor: NSLayoutConstraint?
    private var menuViewBottomAnchor: NSLayoutConstraint?
    private var menuViewWidthAnchor: NSLayoutConstraint?
    
    private var recordsButton: UIButton = {
        let recordsButton = UIButton()
        recordsButton.backgroundColor = .systemBlue
        recordsButton.setTitle("Records", for: .normal)
        recordsButton.setTitleColor(UIColor.white, for: .normal)
        recordsButton.addShadow()
        recordsButton.translatesAutoresizingMaskIntoConstraints = false
        return recordsButton
    }()
    
    private var settingsButton: UIButton = {
        let settingsButton = UIButton()
        settingsButton.backgroundColor = .systemBlue
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.addShadow()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        return settingsButton
    }()
    
    private var isAppear: Bool = false

    // MARK: - IBOutlets
    @IBOutlet weak var raceButtonLabel: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "colorYellow")
        let leftButton = UIBarButtonItem(customView: burgerButton)
        navigationItem.leftBarButtonItem = leftButton
        
        setUpBurgerButton()
        setUpMenuView()
        setUpRecordsButton()
        setUpSettingsButton()
        
        addParallaxToView(view)
        
        raceButtonLabel.addShadow()
        raceButtonLabel.addCornerRadius()
        raceButtonLabel.setTitle(L10n.raceButton, for: .normal)
        customFont()
        scoreLabel.font = UIFont(name: "Merriweather-Regular", size: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.backgroundColor = .white
        menuView.layer.cornerRadius = 30
        menuView.layer.maskedCorners = [.layerMaxXMinYCorner]
        recordsButton.layer.cornerRadius = 15
        settingsButton.layer.cornerRadius = 15
        
        raceButtonLabel.titleLabel?.font = UIFont(name: "Merriweather-Bold", size: 15)
        
//        let button = UIButton(type: .roundedRect)
//              button.frame = CGRect(x: 50, y: 100, width: 100, height: 30)
//              button.setTitle("Test Crash", for: [])
//              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//              view.addSubview(button)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        menuViewLeadingAnchor?.constant = -view.frame.width / 2.3
        view.removeBlur()
        isAppear = false
    }
    
    // MARK: - IBActions
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//          let numbers = [0]
//          let _ = numbers[1]
//    }
    
    @IBAction func raceButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: L10n.aletMessage, preferredStyle: .alert)
        alert.addTextField()
        let submitAction = UIAlertAction(title: L10n.alertSubmit, style: .default) { _ in
            let name = alert.textFields?.first?.text
            User.singleton.userName = name!
    
            self.showRace()
        }
        let cancelAction = UIAlertAction(title: L10n.alertCancel, style: .cancel)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Private Functions
    private func setUpBurgerButton() {
        view.addSubview(burgerButton)
        
        burgerButton.addTarget(self, action: #selector(pressBurgerButton), for: .touchUpInside)
    }
    
    @objc private func pressBurgerButton() {
        if menuViewLeadingAnchor?.constant == 0 {
            isAppear = false
        } else if menuViewLeadingAnchor?.constant  == -view.frame.width / 2.3 {
            isAppear = true
        }
        
        if isAppear == true {
            menuViewLeadingAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.view.layoutIfNeeded()
            }
            
            // Add BlueEffect when Menu appears
            view.blurView(style: .dark)
            view.bringSubviewToFront(menuView)
        } else {
            menuViewLeadingAnchor?.constant = -view.frame.width / 2.3
            UIView.animate(withDuration: 0.5, delay: 0.0) {
                self.view.layoutIfNeeded()
            }
            view.removeBlur()
        }
        
    }
    
    private func setUpMenuView() {
        view.addSubview(menuView)
        
        menuViewTopAnchor = menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        menuViewBottomAnchor = menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        menuViewWidthAnchor = menuView.widthAnchor.constraint(equalToConstant: view.frame.width / 2.3)
        menuViewLeadingAnchor = menuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -view.frame.width / 2.3)
        
        guard let menuViewTopAnchor = menuViewTopAnchor,
              let menuViewBottomAnchor = menuViewBottomAnchor,
              let menuViewLeadingAnchor = menuViewLeadingAnchor,
              let menuViewWidthAnchor = menuViewWidthAnchor else { return }
        
        menuViewTopAnchor.isActive = true
        menuViewBottomAnchor.isActive = true
        menuViewWidthAnchor.isActive = true
        menuViewLeadingAnchor.isActive = true
    }
    
    private func setUpRecordsButton() {
        menuView.addSubview(recordsButton)
        
        NSLayoutConstraint.activate([
            recordsButton.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 30),
            recordsButton.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20),
            recordsButton.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20),
            recordsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        recordsButton.addTarget(self, action: #selector(showRecords), for: .touchUpInside)
        recordsButton.setTitle(L10n.recordsButton, for: .normal)
    }
    
    private func setUpSettingsButton() {
        menuView.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: recordsButton.bottomAnchor, constant: 30),
            settingsButton.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 20),
            settingsButton.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -20),
            settingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        settingsButton.setTitle(L10n.settingsButton, for: .normal)
        
    }
    
    private func showRace() {
        let storyboard = UIStoryboard(name: "Race", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "RaceViewController") as? RaceViewController else {
            return
        }
        
        // Get data from RaceViewController
        viewController.resultCompletion = { score in
            let customString = "\(L10n.scoreLabel): \(score)"
            let attrString = NSMutableAttributedString(string: customString)
            let range1 = (customString as NSString).range(of: L10n.scoreTotalWord)
            attrString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range1)
            let range2 = (customString as NSString).range(of: L10n.scoreScoreWord)
            attrString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range2)
            let range3 = (customString as NSString).range(of: ":")
            attrString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range3)
            let range4 = (customString as NSString).range(of: score.toString())
            attrString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range4)
            self.scoreLabel.attributedText = attrString
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func showRecords() {
        let storyboard = UIStoryboard(name: "Records", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecordsViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func showSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func customFont() {
        let customString = "\(L10n.scoreLabel): 0"
        let attrString = NSMutableAttributedString(string: customString)
        let range1 = (customString as NSString).range(of: L10n.scoreTotalWord)
        attrString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range1)
        let range2 = (customString as NSString).range(of: L10n.scoreScoreWord)
        attrString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range2)
        let range3 = (customString as NSString).range(of: ":")
        attrString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range3)
        let range4 = (customString as NSString).range(of: "0")
        attrString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: range4)
        self.scoreLabel.attributedText = attrString
    }
    
    private func addParallaxToView(_ view: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
    
}

// MARK: - UI
extension UIView {
    func addShadow(shadowColor: UIColor = .black, offset: CGSize = .init(width: 0, height: 10), opacity: Float = 0.3, radius: CGFloat = 8) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func addCornerRadius() {
        layer.cornerRadius = layer.frame.height / 2
    }
}

// MARK: - Int
extension Int {
    
    // Int to Double
    func toDouble() -> Double {
        Double(self)
    }
    
    // Int to String
    func toString() -> String {
        String(self)
    }
}

// MARK: - Blur
extension UIView {
    func blurView(style: UIBlurEffect.Style) {
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if let view = view as? UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
    
}

// Localization
extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
