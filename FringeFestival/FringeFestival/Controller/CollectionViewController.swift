//
//  CollectionViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 16/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import Foundation
import UIKit


class CollectionViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
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
        viewController.event = indexPath.row
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.sharedDataManager.events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.imageView.image = DataManager.sharedDataManager.events[indexPath.row].image
        cell.nameLabel.layer.borderWidth = 2
        cell.nameLabel.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        cell.nameLabel.text = DataManager.sharedDataManager.events[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if let cell = collectionView.cellForItem(at: indexPath) as? Cell {}
    }
    
    
   
   
    
    
}
