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
    
    //local data to make the app faster
    var tempData = cellData()
    var cellsData = [cellData?]()

    // local data to make the app faster
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.dataSource = self
        title = "Work Plan"
        navigationItem.hidesBackButton = true
        self.tableView.rowHeight = 204
                
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        cellsData = [cellData?](repeating: nil, count:  (trainerData.TrainPlan?.exercises.count) ?? 0  )
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
        cell.e_type.text = item?.type
        var temp=String(item?.restBetweenSets ?? 0)
        if(temp == "0"){
            temp=""
        }
        cell.e_restTextField.text = temp
        if(cell.e_restTextField.text != ""){
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        return cell
    }

    
    @IBAction func PlanToMain(_ sender: Any) {
        self.performSegue(withIdentifier: K.planToTrain, sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        
        if segue.identifier == K.planToTrain{
            let trainingVC = segue.destination as! trainViewController
            openMongoDBRealm()
            trainingVC.trainerData = self.trainerData
                }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! MessageCell
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            if (cellsData.isEmpty == false) {
                cellsData[indexPath.row]?.isChecked=false
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tempData.c_weight=cell.e_weightTextField.text ?? ""
            tempData.c_reps=cell.e_repsTextField.text ?? ""
            tempData.c_rest=Int(cell.e_restTextField.text ??  "0")
            tempData.c_sets=cell.e_setsTextField.text ?? ""
            tempData.isChecked=true
            cellsData[indexPath.row]=tempData
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
            
    
            func onRealmOpened(_ realm: Realm){
                /*
                 If cell has checkmark
                 UPDATE data in realm
                 */

                if (cellsData.isEmpty == false){
                try! realm.write{
                    for i in 0..<(trainerData.TrainPlan?.exercises.count ?? 0)
                    {
                        if(cellsData[i]?.isChecked == true){
                            trainerData.TrainPlan?.exercises[i].weight = cellsData[i]?.c_weight ?? ""
                            trainerData.TrainPlan?.exercises[i].reps = cellsData[i]?.c_reps ?? ""
                            trainerData.TrainPlan?.exercises[i].sets = cellsData[i]?.c_sets  ?? ""
                            trainerData.TrainPlan?.exercises[i].restBetweenSets = cellsData[i]?.c_rest ?? nil
                        }else{
                            trainerData.TrainPlan?.exercises[i].weight = ""
                            trainerData.TrainPlan?.exercises[i].reps =  ""
                            trainerData.TrainPlan?.exercises[i].sets = ""
                            trainerData.TrainPlan?.exercises[i].restBetweenSets =  nil
                        }
                    }
                
                }
                print(trainerData)
            }

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

