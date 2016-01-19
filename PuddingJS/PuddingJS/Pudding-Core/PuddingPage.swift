//
//  PuddingPage.swift
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/1.
//  Copyright © 2016年 苏打水. All rights reserved.
//

import UIKit

public class PuddingPage: UIViewController {
    public func fromUrlOrFile(urlOrFile:String){
        print(urlOrFile)
        
        if nil == self.template {
            self.template = SamuraiTemplate();
            self.template.responder = self;
        }
        
        if urlOrFile.hasPrefix("http") {
            self.template.loadURL(urlOrFile, type: nil)
        }else{
            self.template.loadFile(urlOrFile)
        }
    }
}

extension UIAlertController {
    class func showAlert(
        presentController: UIViewController!,
        title: String!,
        message: String!,
        cancelButtonTitle: String? = "cancel",
        okButtonTitle: String? = "ok") {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
            if (cancelButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))// do not handle cancel, just dismiss
            }
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))// do not handle cancel, just dismiss
            }
            
            presentController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showAlert(
        presentController: UIViewController!,
        title: String!,
        message: String!,
        cancelButtonTitle: String? = "cancel",
        okButtonTitle: String? = "ok",
        okHandler: ((UIAlertAction!) -> Void)!) {
            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
            if (cancelButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))// do not handle cancel, just dismiss
            }
            if (okButtonTitle != nil) {
                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: okHandler))// do not handle cancel, just dismiss
            }
            
            presentController!.presentViewController(alert, animated: true, completion: nil)
    }
}