//
//  Person.swift
//  projrct10
//
//  Created by Tigran on 12/8/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name:String, image:String) {
        self.name = name
        self.image = image
    }
}
