//
//  User.swift
//  fiteasy
//
//  Created by Amir Malamud on 13/06/2022.
//

import Foundation
import RealmSwift


class Trainer: Object, ObjectKeyIdentifiable ,Codable{
    @Persisted(primaryKey: true) var _id: String?
    @Persisted var TrainPlan : Trainer_TrainPlan?
    @Persisted var userEmail: String? 

}
