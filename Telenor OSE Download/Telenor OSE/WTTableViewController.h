//
//  WTTableViewController.h
//  Telenor OSE
//
//  Created by StephenZhu on 13-10-18.
//  Copyright (c) 2013年 StephenZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTableViewController : UITableViewController<UIAlertViewDelegate>
{
    UITextField *tfurl;
    UITextField *tfflodername;
    BOOL isgoodzip;
}

@end
