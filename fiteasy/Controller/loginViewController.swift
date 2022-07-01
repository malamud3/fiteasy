//
//  LoginViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 31/05/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import RealmSwift
import SwiftUI

class loginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    let urlExerciseData = K.FStore.urlExerciseData
    var dataExercise = Trainer_TrainPlan()
    var trainerData = Trainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        performRequest()
        spiner.isHidden=true
      
    }

    
    @IBAction func LoginbtnPressed(_ sender: UIButton) {        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                self.spiner.isHidden=false
                self.openMongoDBRealm()
                self.spiner.startAnimating()
            }
        }
    }
   

    
    // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == K.noPlanUser{
                     let trainPlanVC = segue.destination as! newUserViewController
             trainPlanVC.trainerData = self.trainerData
                 }
         else if segue.identifier == K.hasPlanUser{
             let trainPlanVC = segue.destination as! mainMenuViewController
             trainPlanVC.trainerData = self.trainerData
         }
     }

    
    func openMongoDBRealm() {

        let app = App(id: "fiteasy-tjatq")
        app.syncManager.errorHandler = { error, session in
            guard let syncError = error as? SyncError else {
                fatalError("Unexpected error type passed to sync error handler! \(error)")
            }
            switch syncError.code {
            case .clientResetError:
                if let (path, clientResetToken) = syncError.clientResetInfo() {
                    closeRealmSafely()
                    saveBackupRealmPath(path)
                    SyncSession.immediatelyHandleError(clientResetToken, syncManager: app.syncManager)
                }
            default:
                // Handle other errors...
                ()
            }
        }
        
        // Log in anonymously.
        app.login(credentials: Credentials.anonymous) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                case .success(let user):
                    print("Login as \(user) succeeded!")
                    let user = app.currentUser!

                    // The partition determines which subset of data to access.
                    let partitionValue = "Fiteasy"
                    
                    // Get a sync configuration from the user object.
                    let configuration = user.configuration(partitionValue: partitionValue)
                    // Open the realm asynchronously to ensure backend data is downloaded first.
                    Realm.asyncOpen(configuration: configuration) { (result) in
                        switch result {
                        case .failure(let error):
                            print("Failed to open realm: \(error.localizedDescription)")
                            // Handle error...
                        case .success(let realm):
                            // Realm opened
                            onRealmOpened(realm)
                        }
                    }

                }
            }
        }
        
        func onRealmOpened(_ realm: Realm){
            let trainers=realm.objects(Trainer.self)// get user data

            let t = trainers.where {
                $0.userEmail == Auth.auth().currentUser?.email
            }
            if(t.isEmpty){
                try! realm.write{
                    print("newUser")
               trainerData = Trainer(value: ["_id":Auth.auth().currentUser?.uid ?? "0", "userEmail":Auth.auth().currentUser?.email ?? "0" , "TrainPlan": self.dataExercise])
                    realm.add(trainerData)
                    self.performSegue(withIdentifier: K.noPlanUser, sender: self)

                }
            }else{
                trainerData=t.first ?? Trainer(value: ["_id":Auth.auth().currentUser?.uid ?? "0", "userEmail":Auth.auth().currentUser?.email ?? "0" , "TrainPlan": self.dataExercise])
                self.performSegue(withIdentifier: K.hasPlanUser, sender: self)

            }
        }




        
        
        func closeRealmSafely() {
            // invalidate all realms
        }

        func saveBackupRealmPath(_ path: String) {
            // restore the local changes from the backup file at the given path
        }


}
    func performRequest() {
       if let url = URL(string: self.urlExerciseData) {
           let session = URLSession.shared
           let task = session.dataTask(with: url) { (data, response, error) in
                   if error != nil {
                       return
                   }
               self.parseJSON(data!)
           }
           task.resume()
       }
   }
    
   
   func parseJSON(_ data: Data) {
       let decoder = JSONDecoder()
       do {
          
           let decodedData = try decoder.decode(Trainer_TrainPlan.self, from: data)
           let exercises = decodedData.exercises
           self.dataExercise.exercises = exercises
           self.dataExercise.restbetwExercises = 0
       } catch {
           return
       }
   }
}
