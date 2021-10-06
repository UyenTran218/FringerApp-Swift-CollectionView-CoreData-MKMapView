//
//  FavouritesViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 17/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class FavouritesViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPaths = collectionView.indexPathsForSelectedItems! as NSArray
        let indexPath = indexPaths[0] as! IndexPath
        let viewController = (segue.destination as! UINavigationController).topViewController as! EventViewController
        viewController.event = DataManager.sharedDataManager.favourites[indexPath.row]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedDataManager.favourites.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.imageView.image = DataManager.sharedDataManager.events[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    
   
    
}

