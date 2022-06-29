//
//  RegisterViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 31/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class registerViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var trainerData = Trainer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       errorLabel.alpha = 0

   }

    @IBAction func registerPressed(_ sender: UIButton) {
        // Validate the fields
        let error = validateFields()
        if error != nil {
            // There's something wrong with the fields, show error message
            self.showError("Error creating user")
       } else {
        print(emailTextField.text!)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e)
                } else{
                    self.trainerData._id = Auth.auth().currentUser?.uid
                    self.trainerData.userEmail = Auth.auth().currentUser?.email
                }

        }
        }
    }

        func validateFields() -> String? {
           
            
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

               return "Please fill in all fields."
            }
            
           // Check if the password is secure
          //  let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
//            if Utilities.isPasswordValid(cleanedPassword) == false {
//                // Password isn't secure enough
//                return "6 characters,special character and a number."
//        }


            return nil
    }
    
    
func showError(_ message:String) {
    
    errorLabel.text = message
    errorLabel.alpha = 1
}
    
    
    

    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == K.registerSegue{
//            let trainPlanVC = segue.destination as! loginViewController
//            trainPlanVC.trainerData = self.trainerData
//                }
//    }
  

}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
    }
        }
    }
}
