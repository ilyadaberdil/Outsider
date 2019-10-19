//
//  ViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, OutSiderContentProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        print("Options VC TAPPED!")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Settings.rawValue) as? SettingsViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Options"
        
        navigationController?.navigationBar.barTintColor = .green
    }
    
    
}


extension OptionsViewController {
    func contentWillAppear() {
        print("Options WillAppear")
    }
    func contentWillDisappear() {
        print("Options WillDisappear")
    }
    func contentDidAppear() {
        print("Options DidAppear")
    }
    func contentDidDisappear() {
        print("Options DidDisappear")
    }
}
