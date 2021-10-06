//
//  Interested.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 11/11/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import Foundation
class Interested : NSObject {
    private var storedResult: String = ""
    
    
    var success: String {
        get {return storedResult}
        
    }
    
    init(success: String) {
        super.init()
        
        storedResult = success
    }
}
