
//  Utilities.swift
//  fiteasy
//
//  Created by Amir Malamud on 31/05/2022.
//
import UIKit

class Utilities {
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func confingView(_ view:UIView){
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 9.0, height: 8.0)
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 9.0
        view.layer.cornerCurve = CALayerCornerCurve.circular
    }
    static func confingImg(_ img: UIImageView){
    img.layer.borderWidth = 1
    img.layer.masksToBounds = false
    img.layer.borderColor = UIColor.black.cgColor
    img.clipsToBounds = true
}
}
