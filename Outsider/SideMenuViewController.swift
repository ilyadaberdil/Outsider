//
//  SideMenuViewController.swift
//  SdM
//
//  Created by berdil karaçam on 1.07.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, OutSiderMenuProtocol {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func mainButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Main.rawValue) as? MainViewController
        showContent(viewController: vc!)
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Options.rawValue) as? OptionsViewController
        showContent(viewController: vc!)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Settings.rawValue) as? SettingsViewController
        showContent(viewController: vc!, shouldEmbedInNavigationController: false)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Profile.rawValue) as? ProfileViewController
        showContent(viewController: vc!)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.About.rawValue) as? AboutViewController
        let Nvc = UINavigationController(rootViewController: vc!)
        showContent(viewController: Nvc, shouldEmbedInNavigationController: false)
    }
    
}

extension SideMenuViewController {
    func menuWillAppear() {
        print("Menu WillAppear")
    }
    func menuWillDisappear() {
        print("Menu WillDisappear")
    }
    func menuDidAppear() {
        print("Menu DidAppear")
    }
    func menuDidDisappear() {
        print("Menu DidDisappear")
    }
}
