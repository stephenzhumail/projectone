//
//  UIWebViewController.h
//  PlatformProduction
//
//  Created by zhu zhipeng on 12-2-10.
//  Copyright (c) 2012年 Smart-Array. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewController : UIViewController<UIWebViewDelegate>
{
    
    NSString *html;
//    NSString *path;
    NSMutableDictionary* dic;
    NSString *strNewsTitleRequestResult;
    NSThread *thread;
    NSString *strRequest;
    NSString* desc;
    
}
- (id)init:(NSString*)index_html;


@end
