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