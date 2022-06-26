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

    var trainerData = Trainer()
    override func viewDidLoad() {
        print("fewfewfwefew")

        print(trainerData)

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.PlanToMain{
                    let trainingVC = segue.destination as! mainMenuViewController
            trainingVC.trainerData = self.trainerData
                }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = trainerData.TrainPlan?.exercises[indexPath.row]
            
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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

