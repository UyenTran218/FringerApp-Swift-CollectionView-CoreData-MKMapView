//
//  BrowsingViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 10/11/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class BrowsingViewController: DetailViewController, SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBAction func addToFav(_ sender: Any) {
        cardStack.swipe(.right, animated: true)
    }
    
    @IBAction func removeFromFav(_ sender: Any) {
        cardStack.swipe(.left, animated: true)
    }
    /// Create a swipeable card with an image inside
    ///
    /// - Parameter image: event image
    /// - Returns: image card
    func card(fromImage image: UIImage) -> SwipeCard {
        let card = SwipeCard()
        
        card.swipeDirections = [.left, .right, .up]
        card.content = UIImageView(image: image)
        card.contentMode = .scaleAspectFit
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .red
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .green
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
    let cardStack = SwipeCardStack()
    let cardImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.addSubview(cardStack)
        cardStack.frame = imageView.frame.insetBy(dx: 2, dy: 2)
        
        cardStack.dataSource = self
        cardStack.delegate = self
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = cardStack.topCardIndex
        let viewController = (segue.destination as! UINavigationController).topViewController as! EventViewController
        viewController.event = indexPath!
        
    }
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        
        return card(fromImage: DataManager.sharedDataManager.events[index].image)
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return DataManager.sharedDataManager.events.count
    }
    /// Handle swiping actions
    ///
    /// - Parameters:
    ///   - cardStack: SwipeCardStack
    ///   - index: item index
    ///   - direction: swiping direction
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        switch direction{
        case .right:
            DataManager.sharedDataManager.addItemToFavourites(eventNumber: Int(DataManager.sharedDataManager.events[index].id))
            break
        case .left:
            DataManager.sharedDataManager.deleteItemFromFavourites(eventID: Int(DataManager.sharedDataManager.events[index].id))
            
            break
        case .up:
            DataManager.sharedDataManager.registerEmail(id: Int(DataManager.sharedDataManager.events[index].id))
            showInputDialog()
            break
        default:
            break
        }
    }
    
    /// Show Dialog to get user email
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Register For Attend ", message: "Enter your email", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            //getting the input values from user
            let email = alertController.textFields?[0].text
            
            let alert = UIAlertController(title: "Thank you for registering", message: "You have registered with email address " + email!, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Email"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
    }
}

