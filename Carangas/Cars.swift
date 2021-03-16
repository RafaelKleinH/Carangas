//
//  car.swift
//  Carangas
//
//  Created by Rafael Hartmann on 15/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

class Cars: Codable {
    
    var _id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0
    
    var gas: String{
        switch gasType {
        case 0:
            return "Flex"
        case 2:
            return "Álcool"
        default:
            return "Gasolina"
        }
        
    }
    
}
