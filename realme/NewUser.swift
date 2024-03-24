//
//  NewUser.swift
//  realme
//
//  Created by Chingiz on 20.03.2024.
//

import Foundation
import RealmSwift

class NewUser: Object {
    @Persisted var name: String
    @Persisted var surname: String
    @Persisted var password: String
    
}

