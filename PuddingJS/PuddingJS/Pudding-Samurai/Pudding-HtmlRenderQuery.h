//
//  Pudding-HtmlRenderQuery.h
//  Pudding-JS
//
//  Created by 苏打水 on 16/1/16.
//  Copyright © 2016年 苏打水. All rights reserved.
//

//目前的swift还不能支持Samurai_HtmlRenderQuery.h中SamuraiHtmlRenderQueryBlockN的可变参数的定义
//typedef SamuraiHtmlRenderQuery * (^SamuraiHtmlRenderQueryBlockN)( id first, ... );
//导致在swift中不能调用ATTR、SET_CLASS、ADD_CLASS、REMOVE_CLASS、TOGGLE_CLASS和$
//所以，这里继承了一下SamuraiHtmlRenderQuery，把SamuraiHtmlRenderQueryBlockN改成了固定参数的PuddingHtmlRenderQueryBlockN
//下方ATTR、SET_CLASS、ADD_CLASS、REMOVE_CLASS、TOGGLE_CLASS的实现，全部引用Samurai_HtmlRenderQuery.h的代码
//只是把SamuraiHtmlRenderQueryBlockN替换成PuddingHtmlRenderQueryBlockN，把SamuraiHtmlRenderQuery替换成PuddingHtmlRenderQuery
//如果，swift后续版本能支持了，这里的代码就废弃不用了

#import "Samurai.h"
#import "Samurai_WebCore.h"

@class  PuddingHtmlRenderQuery;
typedef PuddingHtmlRenderQuery * (^PuddingHtmlRenderQueryBlockN)( id first );

@interface PuddingHtmlRenderQuery : SamuraiHtmlRenderQuery

@prop_readonly( PuddingHtmlRenderQueryBlockN,	ATTR );
@prop_readonly( PuddingHtmlRenderQueryBlockN,	SET_CLASS );
@prop_readonly( PuddingHtmlRenderQueryBlockN,	ADD_CLASS );
@prop_readonly( PuddingHtmlRenderQueryBlockN,	REMOVE_CLASS );
@prop_readonly( PuddingHtmlRenderQueryBlockN,	TOGGLE_CLASS );

@end

//给UIViewController扩展一个find方法，用来调用Samurai_HtmlRenderQuery.h中定义的$方法
@interface UIViewController(PuddingUCHtmlRenderQuery)

- (PuddingHtmlRenderQuery *)find:(id)queryString;

@end

@interface UIView(PuddingUVHtmlRenderQuery)

- (PuddingHtmlRenderQuery *)find:(id)queryString;

@end

@interface NSObject(PuddingNSObjectHtmlRenderQuery)

- (PuddingHtmlRenderQuery *)find:(id)queryString;

@end

@interface SamuraiDomNode(PuddingDomNode)

@prop_strong( UIView *,					view );

@end