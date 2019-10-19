//
//  OutSiderViewController.swift
//  SdM
//
//  Created by berdil karaçam on 25.06.2019.
//  Copyright © 2019 berdil karaçam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    fileprivate var outSiderViewController: OutSiderViewController? {
        get {
            return getOutSiderViewController(self)
        }
    }
    
    fileprivate func getOutSiderViewController(_ viewController: UIViewController) -> OutSiderViewController? {
        if let parent = viewController.parent {
            if parent is OutSiderViewController {
                return parent as? OutSiderViewController
            } else {
                return getOutSiderViewController(parent)
            }
        }
        return nil
    }
}

protocol OutSiderContentProtocol: UIViewController {
    func showMenu()
    func contentWillAppear()
    func contentDidAppear()
    func contentWillDisappear()
    func contentDidDisappear()
}

protocol OutSiderMenuProtocol: UIViewController {
    func showContent(viewController: UIViewController, shouldEmbedInNavigationController: Bool)
    func menuWillAppear()
    func menuDidAppear()
    func menuWillDisappear()
    func menuDidDisappear()
}


private var contentDelegate: UInt8 = 0
private var menuDelegate: UInt8 = 0

extension OutSiderContentProtocol {
    func showMenu() {
        outSiderViewController?.showMenu()
    }
    func contentWillAppear() { }
    func contentDidAppear() { }
    func contentWillDisappear() { }
    func contentDidDisappear() { }
    
}

extension OutSiderMenuProtocol {
    func showContent(viewController: UIViewController, shouldEmbedInNavigationController: Bool = true) {
        var contentVC = viewController
        if shouldEmbedInNavigationController {
            contentVC = UINavigationController(rootViewController: viewController)
        }
        outSiderViewController?.showContent(viewController: contentVC)
    }
    func menuWillAppear() { }
    func menuDidAppear() { }
    func menuWillDisappear() { }
    func menuDidDisappear() { }
}

//protocol SideMenuItem: class {
//    var sideMenu: OutSiderViewController? { set get }
//}
//
//private var sideMenux: UInt8 = 0
//
//extension SideMenuItem {
//
//    var sideMenu: OutSiderViewController? {
//        get {
//            return (objc_getAssociatedObject(self, &sideMenux) as? OutSiderViewController)
//        }
//        set {
//            objc_setAssociatedObject(self, &sideMenux, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//    }
//}

struct SetupConfigurations {
    //TODO : Değiştir.! CONTENT VE MENU İLE DİĞER AYARLAR AYNI MODELDE OLMAMALI!
    var contentViewController: UIViewController
    var menuViewController: UIViewController
    var shouldContentEmbedInNavigationController: Bool
    var shouldShowContentViewControllerAfterSetup: Bool
    var shouldHideContentViewControllerNavigationBarWhenScaled: Bool
    var shouldHideContentViewControllerNavigationBarWhenPushed: Bool
    
    init(contentViewController: UIViewController,
         menuViewController: UIViewController,
         shouldContentEmbedInNavigationController: Bool = true,
         shouldShowContentViewControllerAfterSetup: Bool = false,
         shouldHideContentViewControllerNavigationBarWhenScaled: Bool = true,
         shouldHideContentViewControllerNavigationBarWhenPushed: Bool = true) {
        self.contentViewController = contentViewController
        self.menuViewController = menuViewController
        self.shouldContentEmbedInNavigationController = shouldContentEmbedInNavigationController
        self.shouldShowContentViewControllerAfterSetup = shouldShowContentViewControllerAfterSetup
        self.shouldHideContentViewControllerNavigationBarWhenScaled = shouldHideContentViewControllerNavigationBarWhenScaled
        self.shouldHideContentViewControllerNavigationBarWhenPushed = shouldHideContentViewControllerNavigationBarWhenPushed
    }
}

class OutSiderViewController: UIViewController {
    
    fileprivate var contentContainerView = UIView()
    fileprivate var menuContainerView = UIView()
    fileprivate var contentContainerInternalShadowView: UIView?
    
//    fileprivate var contentContainerExternalRadiusView: UIView?
    
    fileprivate var outsiderMenuDelegate: OutSiderMenuProtocol?
    fileprivate var outsiderContentDelegate: OutSiderContentProtocol?
    
    private weak var menuViewController: UIViewController? {
        willSet {
            set(contentViewController: contentViewController, menuViewController: newValue)
        }
        didSet {
            if let controller = oldValue {
                hideViewController(controller)
            }
        }
    }
    
    private weak var contentViewController: UIViewController? {
        willSet {
            set(contentViewController: newValue, menuViewController: menuViewController)
        }
        didSet {
            if let controller = oldValue {
                hideViewController(controller)
            }
        }
    }
    
    private var isContentViewScaledMinSize: Bool = false
    private var contentContainerGesture: UIPanGestureRecognizer?
    
    
    fileprivate var configurations: SetupConfigurations?
    //Setup Options -> BUNLARI CONFIGURATOR OLARAK AYARLA!
    private var sideMenuWidth: CGFloat { // calismiyor suan için
        return 250
    }
    
    var transformedContentWidth: CGFloat {
        let transformedBounds = contentContainerView.bounds.applying(contentContainerView.transform)
        let transformedContentWidth = transformedBounds.width
        return transformedContentWidth
    }
    
    var contentViewControllerXTresholdForExpand: CGFloat {
        return ( UIScreen.main.bounds.width / 5 ) * 4
    }
    
    var contentViewControllerXTresholdForScaled: CGFloat {
        return ( UIScreen.main.bounds.width / 5 )
    }
    
    var contentViewControllerScaledValue: CGFloat {
        return 0.4
    }
    
    var maxOpacity: CGFloat {
        return 0.6
    }
    
    //init
    init(configurations: SetupConfigurations) {
        super.init(nibName: nil, bundle: nil)
        setup(configurations: configurations)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(configurations: SetupConfigurations) {
        let menuContainerView = UIView()
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuContainerView)
        
        menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sideMenuWidth).isActive = true
        menuContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuContainerView.widthAnchor.constraint(equalToConstant: sideMenuWidth).isActive = true
        
        let contentContainerView = UIView()
        contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainerView)
        
        contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewTapped))
        contentContainerView.addGestureRecognizer(tappedGesture)
        
        self.menuContainerView = menuContainerView
        self.contentContainerView = contentContainerView
        
        addPanGestures()
        
        var contentVC = configurations.contentViewController
        if configurations.shouldContentEmbedInNavigationController {
            contentVC = UINavigationController(rootViewController: configurations.contentViewController)
        }
        
        self.contentViewController = contentVC
        self.menuViewController = configurations.menuViewController
        self.configurations = configurations
        
        //TODO: configurations didsetine taşı
        if configurations.shouldShowContentViewControllerAfterSetup {
            showContent()
        } else {
            showMenu(afterSetup: true)
        }
    }
    
    fileprivate func set(contentViewController: UIViewController?, menuViewController: UIViewController?) {
        guard let contentVC = contentViewController, let menuVC = menuViewController else { return }
        
        addChild(contentVC)
        addChild(menuVC)
        
        #warning("Controlleri koy, configure dosyanı ayarla.")
        
        self.contentContainerView.addSubview(contentVC.view)
        
        addInternalShadowViewIfNeeded()
        contentContainerView.layer.masksToBounds = true
        
        self.menuContainerView.addSubview(menuVC.view)
        
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentVC.view.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor).isActive = true
        contentVC.view.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor).isActive = true
        contentVC.view.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor).isActive = true
        contentVC.view.topAnchor.constraint(equalTo: contentContainerView.topAnchor).isActive = true
        
        menuVC.view.trailingAnchor.constraint(equalTo: menuContainerView.trailingAnchor).isActive = true
        menuVC.view.leadingAnchor.constraint(equalTo: menuContainerView.leadingAnchor).isActive = true
        menuVC.view.bottomAnchor.constraint(equalTo: menuContainerView.bottomAnchor).isActive = true
        menuVC.view.topAnchor.constraint(equalTo: menuContainerView.topAnchor).isActive = true
        
        if let contentNavigationRootController = (contentViewController as? UINavigationController)?.viewControllers.first {
            outsiderContentDelegate = contentNavigationRootController as? OutSiderContentProtocol
        } else {
            outsiderContentDelegate = contentViewController as? OutSiderContentProtocol
        }
        outsiderMenuDelegate = menuViewController as? OutSiderMenuProtocol
        
        contentVC.didMove(toParent: self)
        menuVC.didMove(toParent: self)
        
    }
    
    @objc private func contentViewTapped() {
        isContentViewScaledMinSize ? showContent() : nil
    }
    
    fileprivate func addPanGestures() {
        //if you wanna show content when pan containerViewController, you should out of comment these lines.
        //        let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panedView))
        //        rightEdgePanGesture.edges = .right
        //        view.addGestureRecognizer(rightEdgePanGesture)
        
        let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panedView))
        leftEdgePanGesture.edges = .left
        view.addGestureRecognizer(leftEdgePanGesture)
        contentContainerGesture = UIPanGestureRecognizer(target: self, action: #selector(panedView))
        contentContainerView.addGestureRecognizer(contentContainerGesture!)
    }
    
    @objc private func panedView(sender:UIScreenEdgePanGestureRecognizer){
        
        //block when content show as full screen and if user swipe from right to left
        //block when content show as preview and if user swipe from left to right
        if (sender.velocity(in: view).x < 0 && contentContainerView.frame.size.width == UIScreen.main.bounds.width) || (sender.velocity(in: view).x > 0 && isContentViewScaledMinSize) {
            return
        }
        
        switch sender.state {
            
        case .changed:
            setContentViewControllerNavigationBar(isHidden: configurations?.shouldHideContentViewControllerNavigationBarWhenScaled)
            
            var contentScaleValue = ((UIScreen.main.bounds.width - sender.location(in: self.view).x) / 1000) * 2
            var menuTransformValue = sender.location(in: self.view).x
            contentScaleValue = contentScaleValue < contentViewControllerScaledValue ? contentViewControllerScaledValue : contentScaleValue
            menuTransformValue = menuTransformValue > menuContainerView.frame.size.width ? menuContainerView.frame.size.width : menuTransformValue
            
            isContentViewScaledMinSize = false
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.menuContainerView.transform = CGAffineTransform(translationX: menuTransformValue, y: 0)
                            self.contentContainerView.layer.cornerRadius = 50
                            self.contentContainerView.transform = CGAffineTransform(scaleX: contentScaleValue, y: contentScaleValue)
                                .translatedBy(x: sender.location(in: self.view).x, y: 0)
                            let shadowOpacity = (sender.location(in: self.view).x / UIScreen.main.bounds.maxX) > self.maxOpacity ? self.maxOpacity : (sender.location(in: self.view).x / UIScreen.main.bounds.maxX)
                            self.contentContainerInternalShadowView?.layer.shadowOpacity = Float(shadowOpacity)
                            print("YO : \(sender.location(in: self.view).x / UIScreen.main.bounds.maxX)")
            })
            
        case .ended:
            if (sender.velocity(in: view).x < 0) {
                if sender.location(in: view).x < contentViewControllerXTresholdForExpand, !(contentContainerView.frame.size.width == UIScreen.main.bounds.width) {
                    showContent()
                } else {
                    showMenu()
                }
            } else {
                if sender.location(in: view).x > contentViewControllerXTresholdForScaled {
                    showMenu()
                } else {
                    showContent()
                }
            }
        default:
            break
        }
    }
    
    fileprivate func hideViewController(_ targetViewController: UIViewController) {
        targetViewController.willMove(toParent: nil)
        targetViewController.view.removeFromSuperview()
        targetViewController.removeFromParent()
    }
    
    private var isContentVCFirstTimeScaled: Bool = true
    
    private func setControls(isContentShown: Bool) {
        if isContentShown {
            isContentViewScaledMinSize = false
            contentViewController?.view.isUserInteractionEnabled = true
            contentContainerView.removeGestureRecognizer(contentContainerGesture!)
            setContentViewControllerNavigationBar(isHidden: configurations?.shouldHideContentViewControllerNavigationBarWhenPushed)
        } else {
            isContentViewScaledMinSize = true
            if isContentVCFirstTimeScaled {
                setupContentContainerInternalShadowViewShadow()
                isContentVCFirstTimeScaled = false
            }
            contentViewController?.view.isUserInteractionEnabled = false
            contentContainerView.addGestureRecognizer(contentContainerGesture!)
            setContentViewControllerNavigationBar(isHidden: configurations?.shouldHideContentViewControllerNavigationBarWhenScaled)
        }
    }
    
    fileprivate func setContentViewControllerNavigationBar(isHidden: Bool?) {
        (contentViewController as? UINavigationController)?.setNavigationBarHidden(isHidden ?? false, animated: false)
    }
    
    fileprivate func addInternalShadowViewIfNeeded() {
        guard contentContainerInternalShadowView == nil else {
            contentContainerView.bringSubviewToFront(contentContainerInternalShadowView!)
            return
        }
        let shadowView = UIView(frame: .zero)
        contentContainerView.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            .init(item: shadowView, attribute: .top, relatedBy: .equal, toItem: contentContainerView, attribute: .top, multiplier: 1, constant: 0),
            .init(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: contentContainerView, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: shadowView, attribute: .leading, relatedBy: .equal, toItem: contentContainerView, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: shadowView, attribute: .trailing, relatedBy: .equal, toItem: contentContainerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        shadowView.isUserInteractionEnabled = false
        
        self.contentContainerInternalShadowView = shadowView
        contentContainerView.bringSubviewToFront(contentContainerInternalShadowView!)
    }
    
    fileprivate func setupContentContainerInternalShadowViewShadow(radius: CGFloat = 0, color: CGColor = UIColor.black.cgColor, offSet: CGSize = .zero) {
        let layer: CALayer = self.contentContainerInternalShadowView!.layer
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = Float(maxOpacity)
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    fileprivate func clearContentContainerInternalShadowViewShadow() {
        let layer: CALayer = self.contentContainerInternalShadowView!.layer
        layer.shadowOpacity = 0.0
    }
    
    
//    #warning("BU OLMADI")
//    fileprivate func addExternalRoundedViewIfNeeded(contentView: UIView) {
//        guard contentContainerExternalRadiusView == nil else {
//            contentContainerExternalRadiusView!.addSubview(contentView)
//            setupContentContainerExternalShadowViewShadow()
//            return
//        }
//        let radiusView = UIView(frame: .zero)
//        contentContainerView.addSubview(radiusView)
//        radiusView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            .init(item: radiusView, attribute: .top, relatedBy: .equal, toItem: contentContainerView, attribute: .top, multiplier: 1, constant: 0),
//            .init(item: radiusView, attribute: .bottom, relatedBy: .equal, toItem: contentContainerView, attribute: .bottom, multiplier: 1, constant: 0),
//            .init(item: radiusView, attribute: .leading, relatedBy: .equal, toItem: contentContainerView, attribute: .leading, multiplier: 1, constant: 0),
//            .init(item: radiusView, attribute: .trailing, relatedBy: .equal, toItem: contentContainerView, attribute: .trailing, multiplier: 1, constant: 0)
//        ])
//        radiusView.addSubview(contentView)
//        radiusView.layer.masksToBounds = true
//        radiusView.layer.cornerRadius = 50
//
//        self.contentContainerExternalRadiusView = radiusView
//        setupContentContainerExternalShadowViewShadow()
//    }
//
//    fileprivate func setupContentContainerExternalShadowViewShadow(radius: CGFloat = 8, color: CGColor = UIColor.black.cgColor, offSet: CGSize = .zero) {
//        let layer: CALayer = self.contentContainerView.layer
//        layer.masksToBounds = false
//        layer.shadowColor = color
//        layer.shadowOpacity = 0.2
//        layer.shadowOffset = offSet
//        layer.shadowRadius = 55
//
//        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
//    }
//
//    fileprivate func clearContentContainerExternalShadowViewShadow() {
//        let layer: CALayer = self.contentContainerView.layer
//        layer.shadowOpacity = 0.0
//    }
    
    func changeConfigurations(configurations: SetupConfigurations) {
        self.configurations = configurations
    }
}

extension OutSiderViewController {
    
    func showMenu(afterSetup: Bool = false) {
        outsiderContentDelegate?.contentWillDisappear()
        outsiderMenuDelegate?.menuWillAppear()
        
        UIView.animate(withDuration: afterSetup ? 0.0 : 0.2, animations: {
            self.contentContainerView.layer.cornerRadius = 50
            self.setupContentContainerInternalShadowViewShadow()
            self.contentContainerView.transform = CGAffineTransform(scaleX: self.contentViewControllerScaledValue, y: self.contentViewControllerScaledValue).translatedBy(x: self.sideMenuWidth + self.sideMenuWidth / 2, y: 0)
            self.menuContainerView.transform = CGAffineTransform(translationX: self.sideMenuWidth, y: 0)
        },completion: { _ in
            self.setControls(isContentShown: false)
            self.outsiderMenuDelegate?.menuDidAppear()
            self.outsiderContentDelegate?.contentDidDisappear()
        })
    }
    
    func showContent(viewController: UIViewController?) {
        contentViewController = viewController
        showContent()
    }
    
    fileprivate func showContent() {
        outsiderContentDelegate?.contentWillAppear()
        outsiderMenuDelegate?.menuWillDisappear()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.clearContentContainerInternalShadowViewShadow()
            self.contentContainerView.layer.cornerRadius = 0
            self.contentContainerView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
            self.menuContainerView.transform = CGAffineTransform(translationX: -self.sideMenuWidth, y: 0)
        }, completion: { _ in
            self.setControls(isContentShown: true)
            self.outsiderContentDelegate?.contentDidAppear()
            self.outsiderMenuDelegate?.menuDidDisappear()
        } )
    }
}








//
//    fileprivate func removeMotionEffects(_ targetView: UIView) {
//        let targetViewMotionEffects = targetView.motionEffects
//        for effect in targetViewMotionEffects {
//            targetView.removeMotionEffect(effect)
//        }
//    }
//
// MARK: Private Properties: Shadow for ContentView
//    @IBInspectable var contentViewShadowEnabled: Bool = true
//    @IBInspectable var contentViewShadowColor: UIColor = UIColor.black
//    @IBInspectable var contentViewShadowOffset: CGSize = CGSize.zero
//    @Inspectable var contentViewShadowOpacity: Float = 0.6
//    @IBInspectable var contentViewShadowRadius: Float = 25.0
//

