//
//  ViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, OutSiderContentProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        print("Settings VC TAPPED!")
        showMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
        navigationController?.navigationBar.barTintColor = .red
    }
    
}


extension SettingsViewController {
    func contentWillAppear() {
        print("Settings WillAppear")
    }
    func contentWillDisappear() {
        print("Settings WillDisappear")
    }
    func contentDidAppear() {
        print("Settings DidAppear")
    }
    func contentDidDisappear() {
        print("Settings DidDisappear")
    }
}
