//
//  helpBot.swift
//  fiteasy
//
//  Created by Amir Malamud on 01/06/2022.
//

import UIKit
//import FirebaseCore
//import FirebaseFirestore
import FirebaseAuth
import RealmSwift
import SwiftUI

class myPlanViewController: UITableViewController
{
    let urlExerciseData = K.FStore.urlExerciseData
    var trainerData = Trainer()

    // local data to make the app faster
    var localData : [Bool,String,String,String,String] = []
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.dataSource = self
        title = "Work Plan"
        navigationItem.hidesBackButton = true
        self.tableView.rowHeight = 203
        
     //   tableView.register(UINib(nibName: K.welcomeCellNibName, bundle: nil), forCellReuseIdentifier: K.welcomeCellIdentifier)
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainerData.TrainPlan?.exercises.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = trainerData.TrainPlan?.exercises[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.e_name.text = item?.name
        cell.e_img.loadFrom(URLAddress: item?.imgUrl ?? "" )
        cell.e_repsTextField.text = item?.reps
        cell.e_weightTextField.text = item?.weight
        cell.e_setsTextField.text = item?.sets

        return cell
    }

    
    @IBAction func PlanToMain(_ sender: Any) {
        self.performSegue(withIdentifier: K.PlanToMain, sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == K.PlanToMain{
                    let trainingVC = segue.destination as! mainMenuViewController
            openMongoDBRealm()
            trainingVC.trainerData = self.trainerData
                }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            localData.
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            flag[indexPath.row]=1
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        }
    

    
    
    
        func openMongoDBRealm() {

            let app = App(id: "fiteasy-tjatq")
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
                                self.onRealmOpened(realm)
                            }
                        }

                    }
                }
            }
        }
            
    ta
            func onRealmOpened(_ realm: Realm){
                /*
                 If cell has checkmark
                 UPDATE data in realm
                 */
                var i=0
                
                if((trainerData.TrainPlan?.exercises.isEmpty) != nil){
                try! realm.write{
                    while (i<trainerData.TrainPlan?.exercises.count! ?? 1) {
                        trainerData.TrainPlan?.exercises[i].weight = cell.e_weightTextField.text ?? "10"
                        trainerData.TrainPlan?.exercises[i].reps = cell.e_repsTextField.text ?? "12"
                            trainerData.TrainPlan?.exercises[i].sets = cell.e_setsTextField.text ?? "3"
                            trainerData.TrainPlan?.exercises[i].restBetweenSets = Int(cell.e_restTextField.text ?? "60")
                            
                        }
                    }
                }
                print(trainerData)
            }

        
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {

        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)

        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
}

