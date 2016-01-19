//
//  Pudding-JsDocument.swift
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/2.
//  Copyright © 2016年 苏打水. All rights reserved.
//

import Foundation
import SwiftyJSON

class PuddingJsDocument: SamuraiHtmlDocument {
    var parserFlow: SamuraiHtmlDocumentWorkflow_Parser?
    var renderFlow: SamuraiHtmlDocumentWorkflow_Render?

    
    override class func supportedExtensions() -> [AnyObject] {
        return ["js"]
    }
    
    override class func supportedTypes() -> [AnyObject] {
        return ["text/javascript"]
    }
    
    override class func baseDirectory() -> String {
        return "/www/html"
    }
    
    override func parse() -> Bool {
        if let dataFromString = self.resContent.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            print(dataFromString)
            
            return true
        }
        
        return false
    }
}