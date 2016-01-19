//
//  Pudding-Template.h
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/7.
//  Copyright © 2016年 苏打水. All rights reserved.
//

#import "Samurai_Template.h"

@interface SamuraiTemplate(extension)

//把SamuraiTemplate的私有方法声明为公开方法
- (void)loadMainResource:(SamuraiResource *)resource;
- (void)loadResource:(SamuraiResource *)resource;
- (BOOL)changeState:(TemplateState)newState;

@end

#import "Samurai_HtmlDocumentWorklet_20ParseDomTree.h"

@interface SamuraiHtmlDocumentWorklet_20ParseDomTree(extension)

- (SamuraiHtmlDomNode *)parseHtml:(NSString *)html;

@end