//
//  newUserViewController.swift
//  fiteasy
//
//  Created by Amir Malamud on 16/06/2022.
//

import UIKit
import RealmSwift

class newUserViewController: UIViewController {

    @IBOutlet weak var Start_btn: UIButton!
    let urlExerciseData = K.FStore.urlExerciseData
    var trainerData = Trainer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let trainers=realm.objects(Trainer.self)// get user data
        let t = trainers.where {
            $0.userEmail == trainerData.userEmail
        }
       print(t)
    }
    
    @IBAction func MakeTrainingPlan(_ sender: Any) {
        self.performSegue(withIdentifier: K.firstPlan, sender: self)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.firstPlan{
            let trainPlanVC = segue.destination as! myPlanViewController
            trainPlanVC.trainerData = self.trainerData
                }
    }
    
    

}



