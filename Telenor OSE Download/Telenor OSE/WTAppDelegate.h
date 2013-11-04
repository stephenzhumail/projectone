//
//  WTAppDelegate.h
//  Telenor OSE
//
//  Created by StephenZhu on 13-10-8.
//  Copyright (c) 2013年 StephenZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;


+ (WTAppDelegate *) appDelegate;

- (void)showssss:(NSString*)name;
- (void)showFaildMsg:(NSString*)msg;
@end
