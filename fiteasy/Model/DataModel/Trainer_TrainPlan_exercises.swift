//
//  Trainer_TrainPlan_exercises.swift
//  fiteasy
//
//  Created by Amir Malamud on 01/07/2022.
//

import Foundation
import RealmSwift
class Trainer_TrainPlan_exercises: EmbeddedObject ,Codable {
    @Persisted var imgUrl: String?
    @Persisted var name: String?
    @Persisted var reps: String?
    @Persisted var restBetweenSets: Int?
    @Persisted var sets: String?
    @Persisted var type: String?
    @Persisted var weight: String?
}
