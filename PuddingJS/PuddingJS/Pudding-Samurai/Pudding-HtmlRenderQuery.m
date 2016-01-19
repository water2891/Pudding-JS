//
//  Pudding-HtmlRenderQuery.m
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/16.
//  Copyright © 2016年 苏打水. All rights reserved.
//

#import "Pudding-HtmlRenderQuery.h"

@implementation PuddingHtmlRenderQuery : SamuraiHtmlRenderQuery

- (PuddingHtmlRenderQueryBlockN)ATTR
{
    @weakify( self )
    
    PuddingHtmlRenderQueryBlockN block = (PuddingHtmlRenderQueryBlockN)^ PuddingHtmlRenderQuery * ( NSString * key, NSString * value )
    {
        @strongify( self )
        
        if ( key && value )
        {
            for ( SamuraiHtmlRenderObject * renderObject in self.output )
            {
                [renderObject.customStyle setObject:value forKey:key];
                
                [renderObject restyle];
            }
        }
        
        return self;
    };
    
    return [block copy];
}

- (PuddingHtmlRenderQueryBlockN)SET_CLASS
{
    @weakify( self )
    
    PuddingHtmlRenderQueryBlockN block = (PuddingHtmlRenderQueryBlockN)^ PuddingHtmlRenderQuery * ( NSString * string )
    {
        @strongify( self )
        
        NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ( classes && [classes count] )
        {
            for ( SamuraiHtmlRenderObject * renderObject in self.output )
            {
                [renderObject.customClasses removeAllObjects];
                [renderObject.customClasses addObjectsFromArray:classes];
                
                [renderObject restyle];
            }
        }
        
        return self;
    };
    
    return [block copy];
}

- (PuddingHtmlRenderQueryBlockN)ADD_CLASS
{
    @weakify( self )
    
    PuddingHtmlRenderQueryBlockN block = (PuddingHtmlRenderQueryBlockN)^ PuddingHtmlRenderQuery * ( NSString * string )
    {
        @strongify( self )
        
        NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ( classes && [classes count] )
        {
            for ( SamuraiHtmlRenderObject * renderObject in self.output )
            {
                [renderObject.customClasses addObjectsFromArray:classes];
                
                [renderObject restyle];
            }
        }
        
        return self;
    };
    
    return [block copy];
}

- (PuddingHtmlRenderQueryBlockN)REMOVE_CLASS
{
    @weakify( self )
    
    PuddingHtmlRenderQueryBlockN block = (PuddingHtmlRenderQueryBlockN)^ PuddingHtmlRenderQuery * ( NSString * string )
    {
        @strongify( self )
        
        NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ( classes && [classes count] )
        {
            for ( SamuraiHtmlRenderObject * renderObject in self.output )
            {
                [renderObject.customClasses removeObjectsInArray:classes];
                
                [renderObject restyle];
            }
        }
        
        return self;
    };
    
    return [block copy];
}

- (PuddingHtmlRenderQueryBlockN)TOGGLE_CLASS
{
    @weakify( self )
    
    PuddingHtmlRenderQueryBlockN block = (PuddingHtmlRenderQueryBlockN)^ PuddingHtmlRenderQuery * ( NSString * string )
    {
        @strongify( self )
        
        NSArray * classes = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ( classes && [classes count] )
        {
            for ( SamuraiHtmlRenderObject * renderObject in self.output )
            {
                for ( NSString * class in classes )
                {
                    if ( NO == [renderObject.customClasses containsObject:class] )
                    {
                        [renderObject.customClasses addObject:class];
                    }
                    else
                    {
                        [renderObject.customClasses removeObject:class];
                    }
                }
                
                [renderObject restyle];
            }
        }
        
        return self;
    };
    
    return [block copy];
}

@end


//@implementation UIViewController(PuddingUCHtmlRenderQuery)
//
//- (PuddingHtmlRenderQuery *)find:(id)queryString{
//    return $(queryString);
//}
//
//@end
//
//@implementation UIView(PuddingUVHtmlRenderQuery)
//
//- (PuddingHtmlRenderQuery *)find:(id)queryString{
//    return $(queryString);
//}
//
//@end

@implementation NSObject(PuddingNSObjectHtmlRenderQuery)

- (PuddingHtmlRenderQuery *)find:(id)queryString{
    return $(queryString);
}

@end

@implementation SamuraiDomNode(PuddingDomNode)

@def_prop_dynamic_strong( UIView *, view, setView );

@end

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