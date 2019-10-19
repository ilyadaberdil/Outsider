//
//  MenuMainViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

class ContainerViewController: OutSiderViewController {


        override func viewDidLoad() {
            super.viewDidLoad()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
            view.addGestureRecognizer(tapGesture)
        }
        
        @objc func tapped() {
            print("Container View Controller TAPPED!")
            
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.Main.rawValue) as? MainViewController
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboards.SideMenu.rawValue) as? SideMenuViewController
        
        let setupConfigurations: SetupConfigurations = .init(contentViewController: contentVC!,
                                                             menuViewController: menuVC!,
                                                             shouldContentEmbedInNavigationController: true,
                                                             shouldShowContentViewControllerAfterSetup: false,
                                                             shouldHideContentViewControllerNavigationBarWhenScaled: true,
                                                             shouldHideContentViewControllerNavigationBarWhenPushed: false)
        setup(configurations: setupConfigurations)
    }
}
