//
//  Pudding-HtmlDocumentWorkflow.m
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/19.
//  Copyright © 2016年 苏打水. All rights reserved.
//

#import "Pudding-HtmlDocumentWorkflow.h"
#import "Samurai_HtmlDocumentWorklet_10Begin.h"
#import "Samurai_HtmlDocumentWorklet_20ParseDomTree.h"
#import "Samurai_HtmlDocumentWorklet_30ParseResource.h"
#import "Samurai_HtmlDocumentWorklet_40MergeStyleTree.h"
#import "Samurai_HtmlDocumentWorklet_50MergeDomTree.h"
#import "Samurai_HtmlDocumentWorklet_60ApplyStyleTree.h"
#import "Samurai_HtmlDocumentWorklet_70BuildRenderTree.h"
#import "Samurai_HtmlDocumentWorklet_80Finish.h"

#import "_pragma_push.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation SamuraiHtmlDocumentWorkflow_Render_NotMergeStyleTree

- (id)init
{
    self = [super init];
    if ( self )
    {
        //[self.worklets addObject:[SamuraiHtmlDocumentWorklet_40MergeStyleTree worklet]];
        [self.worklets addObject:[SamuraiHtmlDocumentWorklet_50MergeDomTree worklet]];
        [self.worklets addObject:[SamuraiHtmlDocumentWorklet_60ApplyStyleTree worklet]];
        [self.worklets addObject:[SamuraiHtmlDocumentWorklet_70BuildRenderTree worklet]];
        [self.worklets addObject:[SamuraiHtmlDocumentWorklet_80Finish worklet]];
    }
    return self;
}

- (void)dealloc
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

TEST_CASE( WebCore, HtmlDocumentWorkflow )

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
