//
//  PuddingJsPage.swift
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/1.
//  Copyright © 2016年 苏打水. All rights reserved.
//

import UIKit
import JavaScriptCore
import SwiftyJSON
import ObjectiveC

@objc protocol PuddingJsQueryExport:JSExport{
    func querySelectorAll(id:AnyObject) -> NSArray
}

extension UIResponder: PuddingJsQueryExport{
    public func $(id:AnyObject) -> PuddingHtmlRenderQuery{
        return self.find(id) as PuddingHtmlRenderQuery
    }
    
    public func querySelectorAll(id:AnyObject) -> NSArray {
        var doms = [SamuraiDomNode]()
        let outputs = self.$(id).output
        for output in outputs{
            output.dom.renderer = output as! SamuraiRenderObject
            doms.append(output.dom)
        }
        return doms
    }
}


@objc protocol PuddingJsPageExport:JSExport {
    var uiConfigPath:String?{get}
    
    func setScope(key:String,_ value:JSValue)
    func alert(msg:String, _ title:String, _ callback:JSValue)
    
    //start: to compatible with jQuery
    var documentElement:SamuraiDomNode?{get}
    var readyState:String{get}
    var nodeType:Int{get}
    
    func createDocumentFragment() -> SamuraiDomNode
    func createElement(nodeName:String) -> SamuraiDomNode
    func createHTMLDocument(html:String) -> SamuraiHtmlDocument
    //end
}

//public class PuddingJsPage:PuddingJsQuery{
//    
//}

public class PuddingJsPage: PuddingPage,PuddingJsPageExport{
    public var uiConfigPath:String?
    public var scriptString = ""
    public var context = PuddingJsContext()

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    init(fromUrlOrFile url:String){
        self.uiConfigPath = url
        self.readyState = "loading"
        
        super.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        

        if let path:String = uiConfigPath{
            self.fromUrlOrFile(path)
        }
        
        self.trigger("viewDidLoad",nil)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("didReceiveMemoryWarning")
    }
    


    public func dataChanged(){
        
    }
    
    override public func loadView() {
        super.loadView()
        
        self.context.setObject(self, forKeyedSubscript: "document")
        
        self.context.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }

        self.eval("var uiConfigPath = '\(self.uiConfigPath!)';")
    }

    override public func onTemplateLoading(){
        
    }
    
    override public func onTemplateLoaded() {
        //jQuery的操作基于Dom，为了操作方便，把renderer和view都绑定到dom上
        //后续使用jQuery添加没有渲染过的原始Dom时就可以通过renderer和view这两个属性来判断是否需要渲染
        self.prepareForjQuery(self.template.document.renderTree)
        
        self.context.name = self.navigationItem.title! + " - " + self.uiConfigPath!
        self.documentElement = self.template.document.domTree

        self.eval("var pageTitle = '\(self.navigationItem.title!)';")
        
        //默认脚本
        let jsDocument = SamuraiDocument.resourceAtPath("Pudding.js") as! SamuraiDocument
        self.eval(jsDocument.resContent)
        
        let jqDocument = SamuraiDocument.resourceAtPath("jquery.js") as! SamuraiDocument
        self.eval(jqDocument.resContent)

        let jqPatchDocument = SamuraiDocument.resourceAtPath("jquery_patch.js") as! SamuraiDocument
        self.eval(jqPatchDocument.resContent)
        
        //遍历head自定义脚本
        if nil != self.template.document.domTree && self.template.document.domTree.childs.count()>0{
            let headDom = self.template.document.domTree.childs[0] as! SamuraiDomNode
            for child in headDom.childs{
                let childDom = child as! SamuraiDomNode
                if childDom.nodeName == "script"{
                    if let jsScript = self.loadJs(childDom.getAttribute("src") as! String){
                        self.eval(jsScript + ";\n\n")
                        self.scriptString += jsScript
                    }
                }
            }
        }
        
        print("========scriptString=========")
        print(self.scriptString)
        print("=================")
        
        self.readyState = "complete"
        
        self.trigger("onTemplateLoaded",nil)
        
        self.trigger("onLoad",nil)
    }
    
    override public func onTemplateFailed(){
        super.onTemplateFailed()
    }
    
    override public func onTemplateCancelled(){
        super.onTemplateCancelled()
    }
    
    //start: for jsContext
    public var nodeType = 9
    
    //临时解决方案加载js
    func loadJs(path:String) -> String?{
        var resource:AnyObject?
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            resource = SamuraiResource.resourceWithURL(path)
        }else if path.hasPrefix("//"){
            resource = SamuraiResource.resourceWithURL("http:" + path)
        }else{
            resource = SamuraiResource.resourceAtPath(path)
        }
        
        if nil != resource{
            return resource!.resContent
        }else{
            return nil
        }
    }
    
    public func setScope(key:String,_ value:JSValue){
        if !(value.isUndefined){
            self.scope.setObject(value.toDictionary(), forKeyedSubscript: "list")
            self.dataChanged()
        }
    }
    
    public func alert(msg:String, _ title:String, _ callback:JSValue){
        UIAlertController.showAlert(self, title: title, message: msg, cancelButtonTitle: "取消", okButtonTitle: "确定", okHandler: {
            (UIAlertAction) in
            if !(callback.isUndefined){
                callback.callWithArguments([])
            }
        })
    }
    
    //trigger js event
    public func trigger(event:String, _ data:AnyObject?){
        let js:JSValue = context.objectForKeyedSubscript(event)
        if !js.isUndefined{
            if let d = data{
                js.callWithArguments([d])
            }else{
                js.callWithArguments([])
            }
            
        }
        
        let eventManager:JSValue = context.objectForKeyedSubscript("dispatchEvent")
        if !eventManager.isUndefined{
            if let d = data{
                eventManager.callWithArguments([event,d])
            }else{
                eventManager.callWithArguments([event])
            }
            
        }
    }
    
    public func define(funcName:String,actionBlock:@convention(block) ()->Void){
        context.define(funcName, actionBlock: actionBlock)
    }
    
    public func eval(script: String?) -> JSValue?{
        if let str =  script {
            let result:JSValue? = self.context.evaluateScript(str)
            
            return result
        }else{
            return nil
        }
    }
    
    func doJsCallback(signal: SamuraiSignal){
        let dom = signal.sourceDom,render = signal.sourceRender
        
        if let jsCallback:String = dom.attr["jsclick"] as? String {
            
            let jsFunc:JSValue = context.objectForKeyedSubscript(jsCallback)
            if !jsFunc.isUndefined{
                let domAttr = dom.attr
                var row = -1,section = -1
                if nil != signal.sourceIndexPath{
                    row = signal.sourceIndexPath.row
                    section = signal.sourceIndexPath.section
                }
                
                jsFunc.callWithArguments([render.dom, domAttr, section, row])
                
            }
            
        }
        
        
    }
    //end
    
    //start: to compatible with jQuery
    public var documentElement:SamuraiDomNode?
    public var readyState = "uninitialized"
    
    public func createDocumentFragment() -> SamuraiDomNode{
        var fragment = SamuraiDomNode()
        if nil != self.template && nil != self.template.document && nil != self.template.document.domTree{
            fragment = self.template.document.domTree
            if fragment.tag == "html" && fragment.childs.count() > 1 {
                let bodyDom = fragment.childs[1] as! SamuraiDomNode
                bodyDom.appendNode(SamuraiDomNode())
                fragment = bodyDom.childs.lastObject as! SamuraiDomNode
                fragment.tag = "#document-fragment"
                fragment.type = DomNodeType_Unknown
                fragment.attach(self.template.document)
            }
        }
        return fragment
    }
    
    public func createElement(nodeName:String) -> SamuraiDomNode{
        let element = SamuraiDomNode()
        element.tag = nodeName
        return element
    }
    
    public func createHTMLDocument(html:String) -> SamuraiHtmlDocument{
        let htmlDoc = SamuraiHtmlDocument.resourceWithString("<html><head></head><body></body></html>", type: "text/html", baseURL: "") as! SamuraiHtmlDocument
        
        return htmlDoc
    }
    
    func prepareForjQuery(renderer:SamuraiRenderObject){
        if nil != renderer.dom{
            print(renderer.dom.nodeName)
            renderer.dom.renderer = renderer
            renderer.dom.view = renderer.view
            
        }
        for child in renderer.childs{
            self.prepareForjQuery(child as! SamuraiRenderObject)
        }
    }
    //end
}



@objc public protocol UIViewJSExport:JSExport{
    func val(key:String) -> AnyObject?
    func attr(key:String,_ value:AnyObject?)
//    func attrs(dict:[NSObject : AnyObject]!)
    func call(selector:String)
    func call(selector:String,withObject object:AnyObject?)
    func addClass(key:String) -> NSObject
    func setClass(key:String) -> NSObject
    func removeClass(key:String) -> NSObject
    
    func append(content:JSValue)
    func prepend(content:JSValue)
    func insert(content:JSValue, Before view:UIView)
    func insert(content:JSValue, After view:UIView)
    func remove()
    
    func relayout()
    
    //start: to compatible with jQuery
    var ownerDocument:AnyObject{get}
    var dom:SamuraiDomNode{get}
    //end
}

extension UIView:UIViewJSExport{
    public var ownerDocument:AnyObject{
        get{
            return self.viewController()!
        }
    }
    
    public func viewController() -> UIViewController? {
        for var next = self.superview!; next.isKindOfClass(UIView.self); next = next.superview! {
            let nextResponder: UIResponder = next.nextResponder()!
            if (nextResponder.isKindOfClass(PuddingJsPage.self)){
                return nextResponder as? PuddingJsPage
            }else if (nextResponder.isKindOfClass(UIViewController.self)) {
                return nextResponder as? UIViewController
            }
        }
        return nil
    }
    
//    public func relayout(){
//        self.renderer.relayout()
//    }
    
    public func remove(){
        let superView = self.superview
        if nil != superView{
            let superRenderer = superView?.renderer
            if nil != superRenderer{
                superRenderer?.removeNode(self.renderer.dom)
                superRenderer?.childs.removeObject(self.renderer)
                superRenderer?.relayout()
            }
        }
        
        self.removeFromSuperview();
        
        self.relayout()
    }
    
    public func prepend(content:JSValue){
        
        self.addChildren(content, addMode: 1, by: nil)
        
    }
    
    public func append(content:JSValue){
        
        self.addChildren(content, addMode: 0, by: nil)

    }
    
    public func insert(content:JSValue, After view:UIView){
        
        self.addChildren(content, addMode: 2, by: view)
        
    }
    
    public func insert(content:JSValue, Before view:UIView){
        
        self.addChildren(content, addMode: 3, by: view)
        
    }
    
    //从js端添加UIView
    public func addChildren(content:JSValue, addMode:Int = 0, by:UIView?){
        var type = "text/html"
        
        let html:String
        if content.isString{
            html = content.toString()
        }else{
            html = JSON(content.toObject()).description
            type = "text/json"
        }
        
        var insertIndex = 0
        if nil != by{
            insertIndex = self.renderer.childs.indexOfObject((by?.renderer)!)
        }
        
        if nil == self.template {
            self.template = SamuraiTemplate();
            self.template.responder = self;
        }
        
        self.template.state = TemplateState_Created;
        
        let vc:UIViewController? = self.viewController()
        
        self.template.document = SamuraiDocument.resourceWithString(html, type: type, baseURL: "") as! SamuraiDocument
        
        print(nil == self.template.document.renderTree)
        
        let dom = self.template.document.domTree
        if dom.tag == "html" && dom.childs.count() > 1 {
            let bodyDom = dom.childs[1] as! SamuraiDomNode
            
            bodyDom.attr.setObject(addMode, atPath: "addMode")
            bodyDom.attr.setObject(insertIndex, atPath: "insertIndex")
            
            self.template.document.domTree = bodyDom
            self.template.document.styleTree = vc!.template.document.styleTree
            
            //print("externalStylesheets.count = \(self.template.document.externalStylesheets.count())")
            //print("self.template.document.styleTree = \(self.template.document.styleTree)")
            
            //if self.template.document.externalStylesheets.count() > 0{
            //self.template.loadResource(self.template.document.externalStylesheets[0] as! SamuraiResource)
            //}
            
            let renderFlow = SamuraiHtmlDocumentWorkflow_Render_NotMergeStyleTree(context: self.template.document);
            renderFlow.process()
            
            self.template.changeState(TemplateState_Loaded)
            
            //print("self.template.document.styleTree = \(self.template.document.styleTree)")
            //print("self.template.document.domTree.tag=\(self.template.document.domTree.tag)")

        }
    }
    
    public func addNodes(domTree:SamuraiDomNode, addMode:Int = 0, by:SamuraiDomNode?){
        var insertIndex = 0
        if nil != by && nil != by!.renderer{
            insertIndex = self.renderer.childs.indexOfObject((by!.renderer)!)
        }
        
        if insertIndex == NSNotFound{
            insertIndex = 0
        }
        
        if nil == self.template {
            self.template = SamuraiTemplate();
            self.template.responder = self;
        }
        
        self.template.state = TemplateState_Created;
        
        let vc:UIViewController? = self.viewController()
        
        self.template.document = SamuraiDocument.resourceWithString("<html><head></head><body></body></html>", type: "text/html", baseURL: "") as! SamuraiDocument
        
        let dom = self.template.document.domTree
        if dom.tag == "html" && dom.childs.count() > 1 {
            let bodyDom = dom.childs[1] as! SamuraiDomNode
            
            bodyDom.attr.setObject(addMode, atPath: "addMode")
            bodyDom.attr.setObject(insertIndex, atPath: "insertIndex")
            bodyDom.appendNode(domTree)
            
            self.template.document.domTree = bodyDom
            self.template.document.styleTree = vc!.template.document.styleTree
            
            let renderFlow = SamuraiHtmlDocumentWorkflow_Render_NotMergeStyleTree(context: self.template.document);
            renderFlow.process()
            
            self.template.changeState(TemplateState_Loaded)

        }
    }
    
    public func addClass(key:String) -> NSObject{
        //let vc = self.viewController() as! PuddingJsPage
        //return vc.$(self).ADD_CLASS(key)
        return self.$(self).ADD_CLASS(key)
    }

    public func setClass(key:String) -> NSObject{
//        let vc = self.viewController() as! PuddingJsPage
//        return vc.$(self).SET_CLASS(key)
        return self.$(self).SET_CLASS(key)

    }
    
    public func removeClass(key:String) -> NSObject{
//        let vc = self.viewController() as! PuddingJsPage
//        return vc.$(self).REMOVE_CLASS(key)
        return self.$(self).REMOVE_CLASS(key)
    }

    
    public func call(selector:String){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: nil)
    }
    
    public func call(selector:String,withObject object:AnyObject?){
        NSThread.detachNewThreadSelector(Selector(selector), toTarget:self, withObject: object)
    }
    
    public func attr(key:String,_ value:AnyObject?) {
        SwiftTryCatch.`try`({
            if let str = value as? String {
                self.setValue(str.anyValue(key.toKeyPath), forKeyPath: key.toKeyPath)
            }else{
                self.setValue(value, forKeyPath: key.toKeyPath)
            }
            }, `catch`: { (error) in
                print("JS Error:\(error.description)")
            }, finally: nil)
    }
    
//    public func attrs(dict:[NSObject : AnyObject]!){
//        SwiftTryCatch.`try`({
//            for (key, value) in dict {
//                if let str = value as? String {
//                    dict[key.toKeyPath] = str.anyValue(key.toKeyPath)
//                }
//            }
//            self.setValuesForKeysWithDictionary(dict)
//            }, `catch`: { (error) in
//                print("JS Error:\(error.description)")
//            }, finally: nil)
//    }
    
    public func val(key:String) -> AnyObject?{
        var result:AnyObject?
        SwiftTryCatch.`try`({
            result = self.valueForKeyPath(key.toKeyPath)
            }, `catch`: { (error) in
                print("JS Error:\(error.description)")
            }, finally: nil)
        return result
    }
    
    //start: to compatible with jQuery
    public var dom:SamuraiDomNode{
        get{
            return self.renderer.dom
        }
    }
    //end
}

@objc public protocol domNodeJSExport:JSExport{
    //start: to compatible with jQuery
    var firstChild:SamuraiDomNode?{get}
    var lastChild:SamuraiDomNode?{get}
    var defaultValue:AnyObject?{get}
    var checked:AnyObject?{set get}
    var innerHTML:String{set get}
    var childNodes:AnyObject{get}
    var textContent:String?{get set}
    var nodeName:String{get}
    var nodeType:Int{get}
    var documentElement:SamuraiDomNode{get}
    var parentNode:SamuraiDomNode?{get}
    var previousSibling:SamuraiDomNode?{get}
    var nextSibling:SamuraiDomNode?{get}
    var ownerDocument:AnyObject?{get}
    var renderer:SamuraiRenderObject?{get}
    var attributes:NSMutableDictionary{get}
    var value:AnyObject?{get}
    var view:UIView?{get}
    
    func querySelectorAll(id:AnyObject) -> NSArray
    func appendChild(node:SamuraiDomNode) -> SamuraiDomNode
    func removeChild(node:SamuraiDomNode) -> SamuraiDomNode
    func insertBefore(newnode:SamuraiDomNode, _ existingnode:SamuraiDomNode) -> SamuraiDomNode
    func setAttribute(name:String,var _ value:String)
    func removeAttribute(name:String)
    func getAttribute(name:String) -> AnyObject?
    func cloneNode(deep:Bool) -> AnyObject
    func contains(node:SamuraiDomNode) -> Bool
    func matches(selector:String) -> Bool
    func compareDocumentPosition(node:SamuraiDomNode) -> Int
    //end
}

extension SamuraiDomNode:domNodeJSExport,NSMutableCopying{
    
    //start: to compatible with jQuery
    
    public var value:AnyObject?{
        get{
            if nil != self.view{
                return self.view.val("text")
            }
            return nil
        }
    }
    
    public var nodeName:String{
        get{
            if nil == self.tag{
                return ""
            }else{
                return self.tag
            }
        }
    }
    
    public var ownerDocument:AnyObject?{
        get{
            if nil != self.renderer{
                return self.renderer.view.viewController()
            }else{
                return self.document.renderTree.view.viewController()
            }
        }
    }
    
    public var attributes:NSMutableDictionary{
        get{
            return self.attr
        }
    }
    
    public var documentElement:SamuraiDomNode{
        get{
            return self.root as! SamuraiDomNode
        }
    }
    
    public var parentNode:SamuraiDomNode?{
        get{
            if nil != self.parent{
                return parent
            }
            return nil
        }
    }

    public var previousSibling:SamuraiDomNode?{
        get{
            return self.prev
        }
    }
    
    public var nextSibling:SamuraiDomNode?{
        get{
            return self.next
        }
    }
    
    public var nodeType:Int{
        get{
            var nodeType = 0
            switch self.type{
                case DomNodeType_Document:
                    nodeType = 9
                case DomNodeType_Element:
                    nodeType = 1
                case DomNodeType_Comment:
                    nodeType = 8
                case DomNodeType_Text:
                    nodeType = 3
                case DomNodeType_Data:
                    nodeType = 2
                case DomNodeType_Unknown:
                    nodeType = 11
                default:
                    nodeType = Int(self.type.rawValue)
            }
            return nodeType
        }
    }
    
    public var childNodes:AnyObject{
        get{
            return self.childs
        }
    }
    
    public var textContent:String?{
        get{
            return self.getTextContent()
        }
        set{
            self.text = newValue
            self.removeAllNodes()
            
            self.relayout()
        }
    }
    
    public var innerHTML:String{
        get{
            if self.childs.count() > 0{
                var innerHTML = ""
                for child in self.childs{
                    innerHTML += self.stringify(child as! SamuraiDomNode)
                }
                return innerHTML
            }else{
                return ""
            }
        }
        set{
            let dom = self.parse(newValue)
            if dom.tag == "html" && dom.childs.count() > 1 {
                let bodyDom = dom.childs[1] as! SamuraiDomNode
                
                self.removeAllNodes()
                
                for child in bodyDom.childs.mutableCopy() as! NSMutableArray{
                    let childNode = child as! SamuraiDomNode
                    self.appendChild(childNode)
                }
                
            }
        }
    }
    
    public var firstChild:SamuraiDomNode?{
        get{
            return self.childs.count() > 0 ? self.childs.firstObject as? SamuraiDomNode : nil
        }
    }
    
    public var lastChild:SamuraiDomNode?{
        get{
            return self.childs.count() > 0 ? self.childs.lastObject as? SamuraiDomNode : nil
        }
    }
    
    public var checked:AnyObject?{
        set{
            self.attr.setObject(newValue as! NSObject, atPath: "checked")
        }
        get{
            var checked = false
            if let _ = self.attr.objectForKey("checked"){
                checked = true
            }
            return checked
        }
    }
    
    public var defaultValue:AnyObject?{
        get{
            return self.attr.objectForKey("defaultValue")
        }
    }
    
    public func appendChild(node:SamuraiDomNode) -> SamuraiDomNode{
        if nil != self.view{
            self.view.addNodes(node, addMode: 0, by: nil)
        }
        
        self.appendNode(node)
        node.attach(self.document)
        
        return node
    }
    
    public func removeChild(node:SamuraiDomNode) -> SamuraiDomNode{
        if nil != node.view{
            node.view.remove()
        }
        
        self.removeNode(node)
        node.detach()
        
        return node
    }
    
    public func insertBefore(newnode:SamuraiDomNode, _ existingnode:SamuraiDomNode) -> SamuraiDomNode{
        if nil != self.view && nil != existingnode.view{
            self.view.addNodes(newnode, addMode: 3, by: existingnode)
        }
        
        self.insertNode(newnode, beforeNode: existingnode)
        newnode.attach(self.document)
        
        return newnode
    }
    
    public func setAttribute(name:String,var _ value:String){
        if value == "undefined"{
            value = ""
        }
        self.attr.setObject(value, atPath: name)
        
        switch name{
            case "class":
                if nil != self.renderer{
                    if nil != self.renderer.view{
                        self.renderer.view.setClass(value)
                    }
                }
            default: break
            
        }

    }

    public func getAttribute(name:String) -> AnyObject?{
        return self.attr.objectForKey(name)
    }
    
    public func removeAttribute(name:String){
        self.attr.removeObjectForKey(name)
    }
    
    public func cloneNode(deep: Bool) -> AnyObject {
        return self.mutableCopy()
    }

    public func mutableCopyWithZone(zone: NSZone) -> AnyObject{
        let domNode = SamuraiDomNode()
        
        domNode.tag = self.tag
        domNode.text = self.text
        domNode.type = self.type
        domNode.attr = self.attr.mutableCopy() as! NSMutableDictionary
        domNode.childs = self.childs.mutableCopy() as! NSMutableArray
        
        return domNode
    }
    
    public func contains(node:SamuraiDomNode) -> Bool{
        //var isContains = false
        if self.childs.containsObject(node){
            return true
        }else{
            for child in self.childs{
                return (child as! SamuraiDomNode).contains(node)
            }
        }
        
        return false
    }
    
    public func matches(selector:String) -> Bool{
        let parent:SamuraiDomNode? = self.parent
        print("self=\(self.nodeName),parent=\(parent!.nodeName),selector=\(selector)")
        if nil != parent {
            let matches = parent!.querySelectorAll(selector)
            let len = matches.count()
            if len > 0 {
                for match in matches.reverse() {
                    if match as! SamuraiDomNode == self{
                        return true
                    }
                }
                return false
            } else {
                return false
            }
        } else {
            //处理动态创建的尚未添加到页面中元素
            //应该不存在，因为这里即使创建#document-fragment，也不是脱离document的
            print("处理动态创建的尚未添加到页面中元素")
            return false
        }
    }

    func parse(html:String) -> SamuraiDomNode{
        let worklet = SamuraiHtmlDocumentWorklet_20ParseDomTree()
        let domTree = worklet.parseHtml(html)
        
        return domTree
    }
    
    func stringify(dom:SamuraiDomNode) -> String{
        var start = "",children = "",end = ""
        if nil != dom.tag{
            start = "<\(dom.tag)"
            for (key,value) in dom.attr{
                start += " \(key)=\"\(value)\""
            }
            start += ">"
            end = "</\(dom.tag)>"
        }
        for child in dom.childs{
            children += self.stringify(child as! SamuraiDomNode)
        }
        if let text = dom.text{
            children += text
        }
        
        
        return start + children + end
    }
    
    func getTextContent() -> String{
        var text = ""
        if nil != self.text{
            text += self.text
        }
        
        for child in self.childs{
            text += child.getTextContent()
        }
        
        return text
    }
    
    public func querySelectorAll(id:AnyObject) -> NSArray{
        if nil != self.view{
            return self.view.querySelectorAll(id)
        }
        return []
    }
    
//    var renderObject:SamuraiRenderObject?{
//        get{
//            if nil == self.renderer && nil != self.document && nil != self.document.renderTree{
//                self.renderer = self.queryRenderer(self.document.renderTree)
//            }
//            
//            return self.renderer
//        }
//    }
//    
//    func queryRenderer(baseRenderer:SamuraiRenderObject) -> SamuraiRenderObject?{
//        if nil != baseRenderer.dom && baseRenderer.dom == self{
//            return baseRenderer
//        }else{
//            for child in baseRenderer.childs{
//                return self.queryRenderer(child as! SamuraiRenderObject)
//            }
//        }
//        return nil
//    }
    
    public func compareDocumentPosition(node:SamuraiDomNode) -> Int{
        var pos = 0
        if self != node{
            if self.contains(node){         //a包含b，+16
                pos += 16
            }else if node.contains(self){   //a包含b，+8
                pos += 8
            }
            
            if self.document != node.document{
                //在不同的document
                pos += 1
            }else{
                var object = self;
                
                for ( ;; )
                {
                    if (nil == object.prev){
                        //a在b之前，+4
                        pos += 4
                        break;
                    }else if ( node == object.prev ){
                        //b在a之前，+2
                        pos += 2
                        break;
                    }
                    
                    object = object.prev;
                }
            }
        }else{
            //元素一致，返回0
        }
        
        return pos
    }
    
    func relayout(){
        if nil != self.document && nil != self.document.renderTree{
            self.document.renderTree.view.relayout()
        }
    }
    
    func renderNodes(node:SamuraiDomNode){
        
    }
    //end
}

@objc public protocol htmlDocJSExport:JSExport{
    //start: to compatible with jQuery
    var body:SamuraiDomNode{get}
    //end
}

extension SamuraiHtmlDocument:htmlDocJSExport{
    //start: to compatible with jQuery
    public var body:SamuraiDomNode{
        get{
            return self.getBodyDomNode()
        }
    }
    //end
}

@objc public protocol HtmlRenderJSExport:JSExport{
    //start: to compatible with jQuery
    var view:UIView?{get}
    //end
}

extension SamuraiHtmlRenderElement:HtmlRenderJSExport{
    //start: to compatible with jQuery

    //end
}