//
//  PuddingURLNavigation.swift
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/4.
//  Copyright © 2016年 苏打水. All rights reserved.
//

import Foundation

public class PuddingURLNavigation{
    static let shareInstance = PuddingURLNavigation()
    
    private init() {}
    
    public class func setRootViewController(viewController: UIViewController) {
        PuddingURLNavigation.shareInstance.applicationDelegate().window?!.rootViewController = viewController
    }
    
    public class func pushViewController(viewController: UIViewController, animated: Bool) {
        self.pushViewController(viewController, animated: animated, replace: false)
    }
    
    public class func pushViewController(viewController: UIViewController, animated: Bool, replace: Bool) {
        //检查viewController是否为UINavigationController
        if (viewController is UINavigationController) {
            PuddingURLNavigation.setRootViewController(viewController)
        }
        else {
            //检查是否已存在UINavigationController
            var navigationController: UINavigationController? = PuddingURLNavigation.shareInstance.currentNavigationViewController()
            if navigationController != nil {
                //替换掉navigationController里的最后一个viewController
                if replace {
                    navigationController!.viewControllers.removeLast()
                    let viewControllers = navigationController!.viewControllers + [viewController]
                    navigationController!.setViewControllers(viewControllers, animated: animated)
                }
                else {
                    //推入新的viewController
                    navigationController!.pushViewController(viewController, animated: animated)
                    print("viewControllers.count = \(navigationController!.viewControllers.count)")
                }
            }
            else {
                //创建新的UINavigationController
                navigationController = UINavigationController(rootViewController: viewController)
                PuddingURLNavigation.shareInstance.applicationDelegate().window?!.rootViewController = navigationController
            }
        }
    }
    
    public class func presentViewController(viewController: UIViewController, animated: Bool) {
        //查找currentViewController
        let currentViewController: UIViewController? = PuddingURLNavigation.shareInstance.currentViewController()
        if currentViewController != nil {
            //present
            currentViewController!.presentViewController(viewController, animated: animated, completion: nil)
        }
        else {
            //设为rootViewController
            PuddingURLNavigation.shareInstance.applicationDelegate().window?!.rootViewController = viewController
        }
    }
    
    public class func dismissCurrentAnimated(animated: Bool) {
        let currentViewController: UIViewController? = PuddingURLNavigation.shareInstance.currentViewController()
        if currentViewController != nil {
            if currentViewController!.navigationController != nil {
                if currentViewController!.navigationController!.viewControllers.count == 1 {
                    if currentViewController!.presentingViewController != nil {
                        currentViewController!.dismissViewControllerAnimated(animated, completion: nil)
                    }
                }
                else {
                    currentViewController!.navigationController!.popViewControllerAnimated(animated)
                }
            }
            else if currentViewController!.presentingViewController != nil {
                currentViewController!.dismissViewControllerAnimated(animated, completion: nil)
            }
        }
    }
    
    func applicationDelegate() -> UIApplicationDelegate {
        return UIApplication.sharedApplication().delegate!
    }
    
    class func currentViewController() -> UIViewController {
        return PuddingURLNavigation.shareInstance.currentViewController()
    }
    
    func currentViewController() -> UIViewController {
        let rootViewController: UIViewController? = self.applicationDelegate().window?!.rootViewController
        return self.currentViewControllerFrom(rootViewController!)
    }
    
    class func currentNavigationViewController() -> UIViewController {
        return PuddingURLNavigation.shareInstance.currentNavigationViewController()
    }
    
    func currentNavigationViewController() -> UINavigationController {
        let currentViewController: UIViewController = self.currentViewController()
        return currentViewController.navigationController!
    }
    
    func currentViewControllerFrom(viewController: UIViewController) -> UIViewController {
        if (viewController is UINavigationController) {
            let navigationController: UINavigationController = viewController as! UINavigationController
            return self.currentViewControllerFrom(navigationController.viewControllers.last!)
        }
        else if (viewController is UITabBarController) {
            let tabBarController: UITabBarController = viewController as! UITabBarController
            return self.currentViewControllerFrom(tabBarController.selectedViewController!)
        }
        else if viewController.presentedViewController != nil {
            return self.currentViewControllerFrom(viewController.presentedViewController!)
        }
        else {
            return viewController
        }
        
    }
}