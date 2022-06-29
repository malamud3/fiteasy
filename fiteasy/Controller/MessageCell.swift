//
//  msgTableViewCell.swift
//  fiteasy
//
//  Created by Amir Malamud on 12/06/2022.
//

import UIKit

class MessageCell: UITableViewCell, UITextFieldDelegate {


    @IBOutlet weak var e_name: UILabel!
    @IBOutlet weak var e_img: UIImageView!
    @IBOutlet weak var msgBubble: UIView!
    
    @IBOutlet weak var e_weightTextField: UITextField!
    @IBOutlet weak var e_repsTextField: UITextField!
    @IBOutlet weak var e_setsTextField: UITextField!
    @IBOutlet weak var e_restTextField: UITextField!
    
    @IBOutlet weak var e_type: UILabel!
    @IBOutlet weak var main: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        main.layer.shadowColor = UIColor.gray.cgColor
        main.layer.shadowOffset = CGSize(width: 9.0, height: 8.0)
        main.layer.shadowOpacity = 1.0
        main.layer.masksToBounds = true
        main.layer.cornerRadius = 9.0
        main.layer.cornerCurve = CALayerCornerCurve.circular
        msgBubble.layer.cornerCurve = CALayerCornerCurve.circular
        msgBubble.layer.cornerRadius = 9.0
        
        e_weightTextField.delegate=self
        e_repsTextField.delegate=self
        e_setsTextField.delegate=self
        e_restTextField.delegate=self


    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


