//
//  msgTableViewCell.swift
//  fiteasy
//
//  Created by Amir Malamud on 12/06/2022.
//

import UIKit

class MessageCell: UITableViewCell {


    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var meImgView: UIImageView!
    @IBOutlet weak var msgBubble: UIView!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    
    @IBOutlet weak var main: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        main.layer.shadowColor = UIColor.gray.cgColor
        main.layer.shadowOffset = CGSize(width: 9.0, height: 8.0)
        main.layer.shadowOpacity = 1.0
        main.layer.masksToBounds = true
        main.layer.cornerRadius = 9.0
        main.layer.cornerCurve = CALayerCornerCurve.circular
    }
    
    /// Set up the cell
    func configure() {
      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


