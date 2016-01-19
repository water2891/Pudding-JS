//
//  Pudding-UIViewTemplateLoading.m
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/12.
//  Copyright © 2016年 苏打水. All rights reserved.
//

#import "UIView+TemplateLoading.h"
#import "Pudding-HtmlRenderQuery.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation UIView(PuddingTemplateLoading)

#pragma mark -


- (void)handleTemplate:(SamuraiTemplate *)template
{
    ASSERT( template == self.template );
    
    if ( template.loading )
    {
#if __SAMURAI_UI_USE_CALLCHAIN__
        [self performCallChainWithSelector:@selector(onTemplateLoading) reversed:YES];
#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
        [self onTemplateLoading];
#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
    }
    else if ( template.loaded )
    {
        [template.document configureForView:self];
        
        SamuraiRenderObject * rootRender = template.document.renderTree;
        
        if ( rootRender )
        {
            if ( self.renderer )
            {
                //start: 20160108 by water
                NSLog(@"rootRender.childs.count = %lu",(unsigned long)rootRender.childs.count);
                //                if (rootRender.childs.count == 0){
                //                    [rootRender retainAssociatedObject:rootRender.dom forKey:"dom"];
                //                    [rootRender.dom retainAssociatedObject:rootRender.dom.document forKey:"document"];
                //
                //
                //                    [self.renderer appendNode:rootRender];
                //
                //                    UIView * rootView = [rootRender createViewWithIdentifier:nil];
                //
                //                    if ( rootView )
                //                    {
                //                        [self addSubview:rootView];
                //
                //                        [rootRender bindOutletsTo:self];
                //                    }
                //
                //
                //                }else{
                //end: 20160108 by water
                
                //NSUInteger * insertIndex = (NSUInteger)[rootRender.dom.attr valueForKey:@"insertIndex"];
                
                NSNumber * insertIndex = [rootRender.dom.attr valueForKey:@"insertIndex"];
                NSNumber * addMode = [rootRender.dom.attr valueForKey:@"addMode"];;
                
                SamuraiRenderObject * baseChild = [self.renderer.childs objectAtIndex:insertIndex.unsignedLongValue];
                
                for ( SamuraiRenderObject * childRender in [rootRender.childs reverseObjectEnumerator] )
                {
                    //start: 20160108 by water
                    //防止document被自动释放，释放后将导致后续的Query和样式操作都会报错
                    [childRender retainAssociatedObject:childRender.dom forKey:"dom"];
                    [childRender.dom retainAssociatedObject:rootRender.dom.document forKey:"document"];
                    //end: 20160108 by water
                    
                    //                    switch (addMode.intValue) {
                    //                        case 1:
                    //
                    //                        case 3:
                    //                            [self.renderer insertNode:childRender beforeNode:baseChild];
                    //                            break;
                    //                        case 2:
                    //                            [self.renderer insertNode:childRender afterNode:baseChild];
                    //                            break;
                    //                        default:
                    //                            [self.renderer appendNode:childRender];
                    //                            break;
                    //                    }
                    
                    UIView * childView = [childRender createViewWithIdentifier:nil];
                    
                    if ( childView )
                    {
                        switch (addMode.intValue) {
                            case 1:
                                
                            case 3:
                                [self.renderer insertNode:childRender beforeNode:baseChild];
                                
                                [self insertSubview:childView belowSubview:baseChild.view];
                                break;
                            case 2:
                                [self.renderer insertNode:childRender afterNode:baseChild];
                                
                                [self insertSubview:childView aboveSubview:baseChild.view];
                                break;
                            default:
                                [self.renderer appendNode:childRender];
                                
                                [self addSubview:childView];
                                break;
                        }
                        
                        [childRender bindOutletsTo:self];
                        
                        childRender.dom.view = childView;
                    }
                }
                //start: 20160108 by water
                //                }
                //end: 20160108 by water
            }
            else
            {
                //				self.renderer = rootRender;
            }
            
            [rootRender rechain];
            //	[rootRender relayout];
            
#if __SAMURAI_UI_USE_CALLCHAIN__
            [self performCallChainWithSelector:@selector(onTemplateLoaded) reversed:YES];
#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
            [self onTemplateLoaded];
#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
        }
        else
        {
#if __SAMURAI_UI_USE_CALLCHAIN__
            [self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
            [self onTemplateFailed];
#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
        }
    }
    else if ( template.failed )
    {
#if __SAMURAI_UI_USE_CALLCHAIN__
        [self performCallChainWithSelector:@selector(onTemplateFailed) reversed:YES];
#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
        [self onTemplateFailed];
#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
    }
    else if ( template.cancelled )
    {
#if __SAMURAI_UI_USE_CALLCHAIN__
        [self performCallChainWithSelector:@selector(onTemplateCancelled) reversed:YES];
#else	// #if __SAMURAI_UI_USE_CALLCHAIN__
        [self onTemplateCancelled];
#endif	// #if __SAMURAI_UI_USE_CALLCHAIN__
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( UI, UIView_TemplateLoading )

DESCRIBE( before )
{
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "_pragma_pop.h"
