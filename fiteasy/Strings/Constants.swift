//
//  Constants.swift
//  fiteasy
//
//  Created by Amir Malamud on 01/06/2022.
//

import Foundation

struct K{
    static let appName = "Fiteasy"
    
    static let welcomeCellIdentifier = "welcomeCell"
    static let welcomeCellNibName = "welcomeCell"
    
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
  
    
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let myPlanSegue = "MainToMyPlan"
    static let hasPlanUser = "LoginToMain"
    static let noPlanUser = "noPlanUser"
    static let firstPlan = "firstPlan"
    static let mainToTrain = "mainToTrain"
    static let mainToPlan = "mainToPlan"
    static let PlanToMain = "PlanToMain"

    

    
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let urlExerciseData = "https://api.jsonbin.io/b/62b5d9a7192a674d291670ae/8"
        static let collectionName = "TrainPlan"
        static let weightField = "weight"
        static let repsField = "reps"
        static let setsField = "date"
    }
    
}
