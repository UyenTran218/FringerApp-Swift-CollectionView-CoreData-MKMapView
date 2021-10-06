//
//  Ratings.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 28/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class Ratings: NSObject {
    
    private var storedID: Int32 = 0
    private var storedLike: Int32 = 0
    private var storedDislike: Int32 = 0
    //private var storedResult: String = ""
    
    var id: Int32 {
        get { return storedID }
    }
    var like: Int32 {
        get {return storedLike }
    }
    var dislike: Int32 {
        get {return storedDislike }
    }
    /*var result: String {
        get {return storedResult}
        
    }*/
    
    init(id: Int32, like: Int32, dislike: Int32) {
        super.init()
        storedID = id
        storedLike = like
        storedDislike = dislike
        //storedResult = result
    }
    
    
}
