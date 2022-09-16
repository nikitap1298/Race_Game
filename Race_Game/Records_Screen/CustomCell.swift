//
//  CustomCell.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 13.09.2022.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        firstLabel.text = nil
        secondLabel.text = nil
    }
    
    func setUpFirstLabel(_ text: String) {
        firstLabel.text = text
    }
    
    func setUpSecondLabel(_ score: Int) {
        secondLabel.text = "\(score) points"
    }
}
