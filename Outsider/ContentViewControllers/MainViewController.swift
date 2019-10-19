//
//  ViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, OutSiderContentProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        print("MAIN VC TAPPED!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Main"

        navigationController?.navigationBar.barTintColor = .orange
        let navBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(showSideMenu))
        navigationItem.setLeftBarButton(navBarButton, animated: true)
    }
    
    @objc func showSideMenu() {
        showMenu()
    }
}

extension MainViewController {
    func contentWillAppear() {
        print("Main WillAppear")
    }
    func contentWillDisappear() {
        print("Main WillDisappear")
    }
    func contentDidAppear() {
        print("Main DidAppear")
    }
    func contentDidDisappear() {
        print("Main DidDisappear")
    }
}

