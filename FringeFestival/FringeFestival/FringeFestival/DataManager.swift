//
//  DataManager.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 16/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let sharedDataManager = DataManager()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>()
        
    private var storedFavourites = [Int]()
    private var storedEvents = [Event]()
    private var storedVenue = [Venue]()
    private var storedRating = [Ratings]()
    private var coreDataRatings = [NSObject]()
    
    var eventDelegate: EventViewController?
    var favDele: FavouritesViewController?
    
    var events: [Event]{
        get {return storedEvents}
    }
    var favourites: [Int]{
        get {return storedFavourites}
    }
    var venues: [Venue]{
        get {return storedVenue}
    }
    var rating: [Ratings]{
        get {return storedRating}
        
    }
    
    override init()
    {
        super.init()
        
        //Print Menu List
        
        segueArray.append("Events")
        segueDictionary["Events"] = UIImage(named: "logo")
        segueArray.append("Favourites")
        segueDictionary["Favourites"] = UIImage(named: "logo")
        segueArray.append("Venues")
        segueDictionary["Venues"] = UIImage(named: "logo.png")
        segueArray.append("Browsing")
        segueDictionary["Browsing"] = UIImage(named: "logo.png")
        segueArray.append("About Adelaide Fringe")
        segueDictionary["About Adelaide Fringe"] = UIImage(named: "logo.png")
        segueArray.append("Copyright")
        segueDictionary["Copyright"] = UIImage(named: "logo.png")

        //Load Data From Core Data
        loadEventsFromCoreData()
        loadFavouritesFromCoreData()
        loadRatingsFromCoreData()
        loadVenuesFromCoreData()
        
        refreshEvents()
        getVenueData()
        getRatingData()
        
    }
    //Add an event to Favourite List
    func addItemToFavourites(eventNumber eventID:Int) {
        if (!storedFavourites.contains(eventID)) {
            
            let entity = NSEntityDescription.entity(forEntityName: "Favourites", in:managedContext)
            
            let favourite = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            favourite.setValue(eventID, forKey: "eventID")
            
            do {
                try managedContext.save()
                storedFavourites.append(eventID)
                
                
            }
            catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    //Delete an event from Favourite List
    func deleteItemFromFavourites(eventID: Int)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        let results = try! managedContext.fetch(fetchRequest)
        for result in results{
            let record = result as! NSManagedObject
            let index = checkForFavourite(searchItem: eventID)
            if index > -1 {
                managedContext.delete(record)
                do
                {
                    try managedContext.save()
                    storedFavourites.remove(at: index)
                    
                }
                catch let error as NSError
                {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
        
        
        
    }
    //Load Favourite List From Core Data
    func loadFavouritesFromCoreData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                let record = result as! NSManagedObject
                storedFavourites.append(record.value(forKey: "eventID") as! Int)
            }
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    //Load Event List From Core Data
    func loadEventsFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            var loadedEvents = results as! [NSManagedObject]
            
            for event in loadedEvents {
                let binaryData = event.value(forKey: "image") as! Data
                
                let image = UIImage(data: binaryData)
                let details = event.value(forKey: "details") as! String
                let name = event.value(forKey: "name") as! String
                let id = event.value(forKey: "id") as! Int32
                let artist = event.value(forKey: "artist") as! String
                let venue = event.value(forKey: "venue") as! String
                let like = event.value(forKey: "likes") as! Int32
                let dislike = event.value(forKey: "dislikes") as! Int32
                
                let loadedEvent = Event(id: id, name: name, details: details, image: image!, artist: artist, venue: venue, like: like, dislike: dislike)
                
                storedEvents.append(loadedEvent)
            }
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    // Get Event Data
    func refreshEvents(){
        let url = NSURL(string: "http://www.partiklezoo.com/fringer/")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            if (error != nil) {return; }
            if let json = try? JSON(data: data!) {
                //DispatchQueue.main.async {
                if json.count > 0 {
                    for count in 0...json.count - 1 {
                        let imageURLString = "http://www.partiklezoo.com/fringer/images/" + json[count]["image"].string!
                        let newEvent = Event(id: json[count]["id"].int32Value, name: json[count]["name"].string!, details: json[count]["description"].string!, artist: json[count]["artist"].string!, venue: json[count]["venue"].string!, like: json[count]["likes"].int32Value, dislike: json[count]["dislikes"].int32Value)
            
                        self.addItemToEvents(newEvent, imageURL: imageURLString)
                    }
                    }
                //}
                
            }
        })
        task.resume()
    }
    // Add Event to Event List and save in core data
    func addItemToEvents(_ newItem: Event!, imageURL: String) {
        
        if !checkForEvent(searchItem: newItem)
        {
            
            let entity = NSEntityDescription.entity(forEntityName: "Events", in:managedContext)
            let eventToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            newItem.image = loadImage(imageURL)
            
            eventToAdd.setValue(newItem.image.jpegData(compressionQuality: 1), forKey: "image")
            eventToAdd.setValue(newItem.id, forKey: "id")
            eventToAdd.setValue(newItem.name, forKey: "name")
            eventToAdd.setValue(newItem.details, forKey: "details")
            eventToAdd.setValue(newItem.artist, forKey: "artist")
            eventToAdd.setValue(newItem.dislike, forKey: "dislikes")
            eventToAdd.setValue(newItem.like, forKey: "likes")
            eventToAdd.setValue(newItem.venue, forKey: "venue")
            
            let rateEntity = NSEntityDescription.entity(forEntityName: "Rates", in:managedContext)
            let ratingToAdd = NSManagedObject(entity: rateEntity!, insertInto: managedContext)
            
            
            ratingToAdd.setValue(newItem.id, forKey: "id")
            ratingToAdd.setValue(newItem.dislike, forKey: "dislike")
            ratingToAdd.setValue(newItem.like, forKey: "like")
            
            
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            storedEvents.append(newItem)
            coreDataRatings.append(ratingToAdd)
            storedRating.append(Ratings(id: newItem.id, like: newItem.like, dislike: newItem.dislike))
        }
    }
    
    // Transfer image URL to Image
    func loadImage(_ imageURL: String) -> UIImage {
        var image : UIImage!
        if let url = NSURL(string: imageURL){
            if let data = NSData (contentsOf:  url as URL){
                image = UIImage(data: data as Data)
            }
        }
        return image!
    }
    //Check if an event exist in Event List
    func checkForEvent(searchItem: Event!) -> Bool
    {
        var found = false
        
        if (events.count > 0) {
            for event in events {
                if (event.id == searchItem.id) {
                    found = true
                }
            }
        }
        
        return found
    }
    //Get Venue Data
    func getVenueData(){
        let url = NSURL(string: "http://partiklezoo.com/fringer/?action=venues")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            if (error != nil) {return; }
            if let json = try? JSON(data: data!) {
                
                if json.count > 0 {
                    for count in 0...json.count - 1 {
                    let newVenue = Venue(id: json[count]["id"].int32Value, longitude: json[count]["longitude"].doubleValue, latitude: json[count]["latitude"].doubleValue, name: json[count]["name"].string!)
                    self.addItemToVenues(newVenue)
                    }
                }
            }
        })
        task.resume()
    }
    //Add a Venue to Venue List
    func addItemToVenues(_ newItem: Venue!) {
        
        if !venues.contains(newItem)
        {
            
            let entity = NSEntityDescription.entity(forEntityName: "Venues", in:managedContext)
            let venueToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            venueToAdd.setValue(newItem.id, forKey: "id")
            venueToAdd.setValue(newItem.name, forKey: "name")
            venueToAdd.setValue(newItem.latitude, forKey: "latitude")
            venueToAdd.setValue(newItem.longitude, forKey: "longitude")
         
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            storedVenue.append(newItem)
        }
    }
    //Load Venue from Core Data
    func loadVenuesFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Venues")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            var loadedVenues = results as! [NSManagedObject]
            
            for venue in loadedVenues {
                let name = venue.value(forKey: "name") as! String
                let id = venue.value(forKey: "id") as! Int32
                let latitude = venue.value(forKey: "latitude") as! Double
                let longitude = venue.value(forKey: "longitude") as! Double

                let loadedVenue = Venue(id: id, longitude: longitude, latitude: latitude, name: name)
                storedVenue.append(loadedVenue)
            }
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    //Get Rating Data
    func getRatingData(){
        let url = NSURL(string: "http://partiklezoo.com/fringer/?action=ratings")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            if (error != nil) {return; }
            if let json = try? JSON(data: data!) {
                
                if json.count > 0 {
                    for count in 0...json.count - 1 {
                        let newRating = Ratings(id: json[count]["id"].int32Value, like: json[count]["likes"].int32Value, dislike: json[count]["dislikes"].int32Value)
                        self.addItemToRatings(newRating)
                        
                    }
                }
            }
        })
        task.resume()
    }
    //Register interest
    func registerEmail(id: Int){
        let url = NSURL(string: "http://partiklezoo.com/fringer/?action=register")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url! as URL, completionHandler:
        {(data, response, error) in
            if (error != nil) {return ; }
            if let json = try? JSON(data: data!) {
                let regis = Interested(success: json["success"].stringValue)
            }
        })
        task.resume()
    }
    //Update Like and Dislike number
    func updateRating(id: Int, action: String) {
    //getRatingData()
    let url = NSURL(string: "http://partiklezoo.com/fringer/?action=rate&rating=" + action + "&id=" + String(id) + "&replace=true")
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
        
    let task = session.dataTask(with: url! as URL, completionHandler:
    {(data, response, error) in
    if (error != nil) {return ; }
    if let json = try? JSON(data: data!) {
        let newRating = Ratings(id: json["id"].int32Value, like: json["likes"].int32Value, dislike: json["dislikes"].int32Value)
        
        DispatchQueue.main.async {
            self.addItemToRatings(newRating)
        }
        
       }
    })
    task.resume()
    }
    
    //Check if a Rating record exist in Rating List
    func checkForRating(searchItem: Int) -> Int
    {
        var found = -1
        var count = 0
        
        if (rating.count > 0) {
            for rating in rating {
                if (rating.id == searchItem) {
                    found = count
                }
                count += 1
            }
        }
        
        return found
    }
    //Check if a Event exist in Favourite List
    func checkForFavourite(searchItem: Int) -> Int
    {
        var found = -1
        var count = 0
        
        if (favourites.count > 0) {
            for fav in favourites {
                if (fav == searchItem) {
                    found = count
                }
                count += 1
            }
        }
        
        return found
    }
    //Save Rating to Core Data
    func addItemToRatings(_ newItem: Ratings!) {
        
        //if !checkForRating(searchItem: Int(newItem.id))
        //{
            
            //let entity = NSEntityDescription.entity(forEntityName: "Rates", in:managedContext)
            //let ratingToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        for coreDataRating in coreDataRatings {
            if (coreDataRating.value(forKey: "id") as! Int32 == newItem.id)
            {
                coreDataRating.setValue(newItem.dislike, forKey: "dislike")
                coreDataRating.setValue(newItem.like, forKey: "like")
            }
        }
        
            //ratingToAdd.setValue(newItem.id, forKey: "id")
            

            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
        
            let index = checkForRating(searchItem: Int(newItem.id))
            
            if (index > -1)
            {
                storedRating[index] = newItem
            }
        
            self.eventDelegate?.updateLikesAndDislikes()
        //}
    }
    //Load Rating data from Core Data
    func loadRatingsFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rates")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            var loadedRatings = results as! [NSManagedObject]
            
            for rating in loadedRatings {
                
                let id = rating.value(forKey: "id") as! Int32
                let like = rating.value(forKey: "like") as! Int32
                let dislike = rating.value(forKey: "dislike") as! Int32
                let loadedRating = Ratings(id: id, like: like, dislike: dislike)
                
                storedRating.append(loadedRating)
                coreDataRatings.append(rating)
            }
            
        }
        catch let error as NSError {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    func fromIdToName(venue: Venue) -> String {
        var name = ""
        for event in events{
            if event.venue == venue.name{
                name += event.name + " "
            }
        }
        return name
    }
}
