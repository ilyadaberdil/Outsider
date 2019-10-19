//
//  ViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, OutSiderContentProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        print("Profile VC TAPPED!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profile"
        navigationController?.navigationBar.barTintColor = .blue
    }
    
}


extension ProfileViewController {
    func contentWillAppear() {
        print("Profile WillAppear")
    }
    func contentWillDisappear() {
        print("Profile WillDisappear")
    }
    func contentDidAppear() {
        print("Profile DidAppear")
    }
    func contentDidDisappear() {
        print("Profile DidDisappear")
    }
}

