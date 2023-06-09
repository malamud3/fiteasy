//
//  MainMenuViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 24/06/2022.
//

import UIKit
import NIO
import FirebaseAuth
class mainMenuViewController: UIViewController {
    
    var trainerData = Trainer()


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main Menu"
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func StartTrain(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.mainToTrain, sender: self)

    }
    
    @IBAction func EditPlan(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.mainToPlan, sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.mainToTrain{
                    let trainingVC = segue.destination as! trainViewController
            trainingVC.trainerData = self.trainerData
                }
        else if segue.identifier == K.mainToPlan{
                    let trainPlanVC = segue.destination as! myPlanViewController
            trainPlanVC.trainerData = self.trainerData
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
