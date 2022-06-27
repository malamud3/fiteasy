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

class myPlanViewController: UITableViewController
{
    let urlExerciseData = K.FStore.urlExerciseData
    var trainerData = Trainer()

    var flag:[Int]=[0,0,0,0,0,0]
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.dataSource = self
        title = "Work Plan"
        navigationItem.hidesBackButton = true

        
     //   tableView.register(UINib(nibName: K.welcomeCellNibName, bundle: nil), forCellReuseIdentifier: K.welcomeCellIdentifier)
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainerData.TrainPlan?.exercises.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = trainerData.TrainPlan?.exercises[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = item?.name
        cell.meImgView.loadFrom(URLAddress: item?.imgUrl ?? "" )
        cell.repsTextField.text = item?.reps
        cell.weightTextField.text = item?.weight
        cell.setsTextField.text = item?.sets

        cell.configure()
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
            flag[indexPath.row]=0
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
            
            func onRealmOpened(_ realm: Realm){
                let trainers=realm.objects(Trainer.self)// get user data
                let t = trainers.where {
                    $0.userEmail == Auth.auth().currentUser?.email
                }
                
                try! realm.write{
                    if(flag[0]==1){
                        trainerData.TrainPlan?.exercises[0].weight="3"
                        trainerData.TrainPlan?.exercises[0].reps="3"
                        trainerData.TrainPlan?.exercises[0].sets="3"
                    }
                    if(flag[1]==1){
                        trainerData.TrainPlan?.exercises[1].weight="3"
                        trainerData.TrainPlan?.exercises[1].reps="3"
                        trainerData.TrainPlan?.exercises[1].sets="3"
                    }
                    if(flag[2]==1){
                        trainerData.TrainPlan?.exercises[2].weight="3"
                        trainerData.TrainPlan?.exercises[2].reps="3"
                        trainerData.TrainPlan?.exercises[2].sets="3"
                    }
                    if(flag[3]==1){
                        trainerData.TrainPlan?.exercises[3].weight="3"
                        trainerData.TrainPlan?.exercises[3].reps="3"
                        trainerData.TrainPlan?.exercises[3].sets="3"
                    }
                    if(flag[4]==1){
                        trainerData.TrainPlan?.exercises[4].weight="3"
                        trainerData.TrainPlan?.exercises[4].reps="3"
                        trainerData.TrainPlan?.exercises[4].sets="3"
                    }
                    if(flag[5]==1){
                        
                        trainerData.TrainPlan?.exercises[5].weight="3"
                        trainerData.TrainPlan?.exercises[5].reps="3"
                        trainerData.TrainPlan?.exercises[5].sets="3"
                    }
                }
                print(t)
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

