//
//  UIWebViewController.m
//  PlatformProduction
//
//  Created by zhu zhipeng on 12-2-10.
//  Copyright (c) 2012年 Smart-Array. All rights reserved.
//

#import "UIWebViewController.h"
#import <netinet/in.h>
#import <CFNetwork/CFNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>
@implementation UIWebViewController

- (id)init:(NSString*)index_html 
{
    self = [super init];
    if (self) {
        html = [[NSString alloc]initWithString:index_html];
        desc = nil;
//        path = index_path;

    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
 
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,1024,768)];
    //    NSString *htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:];
    NSString *htmlPath;

        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *sqliteDataPathOld = [documentsDirectory stringByAppendingPathComponent:[ NSString stringWithFormat:@"%@/index.html",html]];
        htmlPath = [[NSString alloc]initWithString:sqliteDataPathOld];
    
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    webview.delegate = self;
    webview.scalesPageToFit = NO;
    [(UIScrollView *)[[webview subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:webview];

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    

}

-(NSString *)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL is3g = flags & kSCNetworkReachabilityFlagsIsWWAN;
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    //    return (isReachable && !needsConnection) ? YES : NO;
    if (isReachable && !needsConnection) {
        if (is3g == YES) {
            return @"您当前使用的是联通WIFI网络";
        }
        else
            return @"您当前使用的是联通3G网络";
    }
    else
        return nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (desc != nil) {
        NSString* str  = [NSString stringWithFormat:@"document.getElementById('li1').innerHTML='%@'",desc];
        [webView stringByEvaluatingJavaScriptFromString:str];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
