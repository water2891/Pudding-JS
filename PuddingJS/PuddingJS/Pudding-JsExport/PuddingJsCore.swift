//
//  PuddingJsCore.swift
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/1.
//  Copyright © 2016年 苏打水. All rights reserved.
//

import UIKit
import JavaScriptCore
import Alamofire


@objc protocol JSURLManagerExport:JSExport {
    static func present(url:String,_ animated:Bool)
    static func push(url:String,_ animated:Bool)
    static func dismiss(animated:Bool)
    static func replace(url:String)
}

public class JSURLManager:NSObject,JSURLManagerExport {
    static public func present(url:String,_ animated:Bool){
        let page = PuddingJsPage(fromUrlOrFile: url)
        PuddingURLNavigation.presentViewController(page, animated: animated)
    }

    static public func push(url:String,_ animated:Bool){
        let page = PuddingJsPage(fromUrlOrFile: url)
        PuddingURLNavigation.pushViewController(page, animated:true)
    }

    static public func dismiss(animated:Bool){
        PuddingURLNavigation.dismissCurrentAnimated(animated)
    }
    
    static public func replace(url:String){
        let page = PuddingJsPage(fromUrlOrFile: url)
        
        PuddingURLNavigation.pushViewController(page, animated:true, replace: true)
    }
}

@objc protocol JQueryExport:JSExport {
    static func get(url:String,_ callback:JSValue)
    
    static func output(object:AnyObject?)
}
public class JQuery:NSObject,JQueryExport {
    static public func get(url:String,_ callback:JSValue){
        Alamofire.request(.GET, url)
            .responseString { response in
                //print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if !(callback.isUndefined){
                    callback.callWithArguments([response.result.value!,response.result.isSuccess])
                }
                
        }
    }
    
    static public func output(object:AnyObject?){
        if let obj: AnyObject = object{
            print(obj)
        }
    }
}


public class PuddingJsContext:JSContext{
    
    override init(){
        super.init()

        //模拟jQuery
        self.setObject(JQuery.self, forKeyedSubscript: "jquery")
        

        //映射页面跳转控制
        self.setObject(JSURLManager.self, forKeyedSubscript: "location")
        //
        //        class_addProtocol(EZAction.self, EZActionJSExport.self)
        //        self.setObject(EZAction.self, forKeyedSubscript: "EZAction")
        //
        //        class_addProtocol(UIColor.self, EUIColor.self)
        //        self.setObject(UIColor.self, forKeyedSubscript: "UIColor")
        //
        //        class_addProtocol(UIImage.self, EUIImage.self)
        //        self.setObject(UIImage.self, forKeyedSubscript: "UIImage")
        //
        //        class_addProtocol(UIView.self, EUIView.self)
        //        self.setObject(UIView.self, forKeyedSubscript: "UIView")
        //
        //        class_addProtocol(UIImageView.self, EUIImageView.self)
        //        self.setObject(UIImageView.self, forKeyedSubscript: "UIImageView")
        //
        //        class_addProtocol(UITextField.self, EUITextField.self)
        //        self.setObject(UITextField.self, forKeyedSubscript: "UITextField")
        //
        //        class_addProtocol(UIButton.self, EUIButton.self)
        //        self.setObject(UIButton.self, forKeyedSubscript: "UIButton")
        //
        //        class_addProtocol(UILabel.self, EUILabel.self)
        //        self.setObject(UILabel.self, forKeyedSubscript: "UILabel")
        //
        //        class_addProtocol(UIScrollView.self, EUIScrollView.self)
        //        self.setObject(UIScrollView.self, forKeyedSubscript: "UIScrollView")
        //
        //        class_addProtocol(UITableView.self, EUITableView.self)
        //        self.setObject(UITableView.self, forKeyedSubscript: "UITableView")
        //
        //        class_addProtocol(UICollectionView.self, EUICollectionView.self)
        //        self.setObject(UICollectionView.self, forKeyedSubscript: "UICollectionView")
        
        class_addProtocol(UIButton.self, PuddingJsUIViewProtocal.self)
        self.setObject(UIButton.self, forKeyedSubscript: "UIButton")

        
        
        
        self.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
    }
    
    override init(virtualMachine: JSVirtualMachine!) {
        super.init(virtualMachine:virtualMachine)
    }
    
    
    public func define(funcName:String,actionBlock:@convention(block) ()->Void){
        self.setObject(unsafeBitCast(actionBlock, AnyObject.self), forKeyedSubscript:funcName)
    }
}

@objc public protocol PuddingJsUIViewProtocal:JSExport,UIViewJSExport{
    
}
