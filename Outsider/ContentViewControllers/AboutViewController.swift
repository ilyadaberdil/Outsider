//
//  ViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, OutSiderContentProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        print("About VC TAPPED!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "About"
        navigationController?.navigationBar.barTintColor = .purple
    }
    
}



extension AboutViewController {
    func contentWillAppear() {
        print("About WillAppear")
    }
    func contentWillDisappear() {
        print("About WillDisappear")
    }
    func contentDidAppear() {
        print("About DidAppear")
    }
    func contentDidDisappear() {
        print("About DidDisappear")
    }
}
