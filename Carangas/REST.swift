//
//  REST.swift
//  Carangas
//
//  Created by Rafael Hartmann on 15/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation


class REST {
     
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type":"application/json" ]
        config.timeoutIntervalForRequest = 30.0
    }()
    
    
    private static let session = URLSession(configuration: )
    
    
    
}
