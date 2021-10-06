//
//  EventViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 16/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class EventViewController: DetailViewController {
    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var dislikesLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var venueLabel: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
   
    @IBOutlet weak var swipeView: UIView!
    
    
    
    private var eventID = -1

    var event: Int {
        get {
            return self.eventID
        }
        set {
            self.eventID = newValue
        }
    }

    
    override func viewDidLoad() {
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        
        
        super.viewDidLoad()
        
        if (eventID >= 0) {
            detailImage.image = DataManager.sharedDataManager.events[eventID].image
            eventName.text = DataManager.sharedDataManager.events[eventID].name
            descriptionView.text = DataManager.sharedDataManager.events[eventID].details
            artistLabel.text = DataManager.sharedDataManager.events[eventID].artist
            venueLabel.text = DataManager.sharedDataManager.events[eventID].venue
            
            //dump(DataManager.sharedDataManager.rating)
            if (eventID < DataManager.sharedDataManager.rating.count) {
                likesLabel.text = String(DataManager.sharedDataManager.rating[eventID].like)
            
                dislikesLabel.text = String(DataManager.sharedDataManager.rating[eventID].dislike)
            }
            
            if (DataManager.sharedDataManager.favourites.contains(eventID))
            {
                favouriteButton.image = UIImage(named: "star-filled")
            }
            else {
                favouriteButton.image = UIImage(named: "star")
            }
            
            DataManager.sharedDataManager.eventDelegate = self
        }
        
        
        
    }
    
    

    
    @IBAction func addItemToFavourites(_ sender: Any) {
        if(favouriteButton.image == UIImage(named: "star-filled")){
            DataManager.sharedDataManager.deleteItemFromFavourites(eventID: eventID)
            favouriteButton.image = UIImage(named: "star")
            
        }else{
            DataManager.sharedDataManager.addItemToFavourites(eventNumber: eventID)
            favouriteButton.image = UIImage(named: "star-filled")
        }
        
    }
    
    @IBAction func likeEvent(_ sender: UIButton) {
        DataManager.sharedDataManager.managedContext.refreshAllObjects()
        likeButton.isEnabled = false
        dislikeButton.isEnabled = true
        DataManager.sharedDataManager.updateRating(id: Int(DataManager.sharedDataManager.rating[eventID].id), action: "like")
       
            likesLabel.text = String(DataManager.sharedDataManager.rating[eventID].like)
            dislikesLabel.text = String(DataManager.sharedDataManager.rating[eventID].dislike)
        
    }
    
    @IBAction func dislikeEvent(_ sender: UIButton) {
       
        dislikeButton.isEnabled = false
        likeButton.isEnabled = true
        DataManager.sharedDataManager.updateRating(id: Int(DataManager.sharedDataManager.rating[eventID].id), action: "dislike")
       
            likesLabel.text = String(DataManager.sharedDataManager.rating[eventID].like)
            dislikesLabel.text = String(DataManager.sharedDataManager.rating[eventID].dislike)
        
    }
    
    func updateLikesAndDislikes() {
        likesLabel.text = String(DataManager.sharedDataManager.rating[eventID].like)
        dislikesLabel.text = String(DataManager.sharedDataManager.rating[eventID].dislike)
    }
}
