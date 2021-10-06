//
//  DetailViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 16/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    func configureView() {
        // Update the user interface for the detail item.
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: UIImage? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    var detailLabel: UILabel? {
        didSet {
            configureView()
        }
    }


}

