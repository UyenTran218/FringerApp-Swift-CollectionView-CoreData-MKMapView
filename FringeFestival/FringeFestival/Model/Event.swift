//
//  Event.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 26/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class Event: NSObject {
    private var storedImage: UIImage = UIImage()
    private var storedName: String = ""
    private var storedDetails: String = ""
    private var storedID: Int32 = 0
    private var storedArtist: String = ""
    private var storedVenue: String = ""
    private var storedLike: Int32 = 0
    private var storedDislike: Int32 = 0
    
    var image: UIImage {
        get { return storedImage }
        set { storedImage = newValue }
    }
    
    var id: Int32 {
        get { return storedID }
    }
    
    var name: String {
        get { return storedName }
    }
    
    var details: String {
        get { return storedDetails }
    }
    var artist: String {
        get {return storedArtist }
    }
    var venue: String {
        get {return storedVenue }
    }
    var like: Int32 {
        get {return storedLike }
    }
    var dislike: Int32 {
        get {return storedDislike}
    }
    
    init(id: Int32, name: String, details: String, image: UIImage, artist: String, venue: String, like: Int32, dislike: Int32) {
        super.init()
        
        storedID = id
        storedName = name
        storedDetails = details
        storedImage = image
        storedDislike = dislike
        storedLike = like
        storedArtist = artist
        storedVenue = venue
    }
    
    init(id: Int32, name: String, details: String, artist: String, venue: String, like: Int32, dislike: Int32) {
        super.init()
        
        storedID = id
        storedName = name
        storedDetails = details
        storedDislike = dislike
        storedLike = like
        storedArtist = artist
        storedVenue = venue
    }
}
