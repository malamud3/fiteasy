//
//  TrainPlan.swift
//  fiteasy
//
//  Created by Amir Malamud on 13/06/2022.
//

import Foundation
import RealmSwift

class Trainer_TrainPlan:EmbeddedObject ,Codable{
    @Persisted var exercises = List<Trainer_TrainPlan_exercises>()
    @Persisted var restbetwExercises:Int? 


}
