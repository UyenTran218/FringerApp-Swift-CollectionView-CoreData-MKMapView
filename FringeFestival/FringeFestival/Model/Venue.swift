//
//  Venue.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 26/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class Venue: NSObject {

    private var storedID: Int32 = 0
    private var storedLongitude: Double = 0
    private var storedLatitude: Double = 0
    private var storedName: String = ""
    
    var id: Int32 {
        get { return storedID }
    }
    var longitude: Double {
        get {return storedLongitude }
    }
    var latitude: Double {
        get {return storedLatitude }
    }
    var name: String {
        get {return storedName}
    }
    
    init(id: Int32, longitude: Double, latitude: Double, name: String) {
        super.init()
        storedID = id
        storedName = name
        storedLatitude = latitude
        storedLongitude = longitude
    }
    
}

