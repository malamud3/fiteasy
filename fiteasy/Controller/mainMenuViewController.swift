//
//  MainMenuViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 24/06/2022.
//

import UIKit
import NIO
class mainMenuViewController: UIViewController {
    
    var trainerData = Trainer()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StartTrain(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.goToMain, sender: self)

    }
    
    @IBAction func EditPlan(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.goToMain, sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.mainToTrain{
                    let trainingVC = segue.destination as! trainViewController
            trainingVC.trainerData = self.trainerData
                }
        else if segue.identifier == K.goToMain{
                    let trainPlanVC = segue.destination as! myPlanViewController
            trainPlanVC.trainerData = self.trainerData
                }
    }
}
