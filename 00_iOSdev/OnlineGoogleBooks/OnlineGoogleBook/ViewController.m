//
//  ViewController.m
//  OnlineGoogleBook
//
//  Created by Ding Orlando on 2/5/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "ViewController.h"
#import "DataModelStore.h"
#import "PersistStatus.h"

NSString* strApisFile = @"iOS6apis";
NSString* strBookId = @"hcz96jeSLe8C";
//NSString* strBookId = @"Py8u3Obs4f4C";
const int iUIActivityIndicatorId = 1001;

@interface ViewController ()

- (void) loadHtmlStringLocally : (NSString*)fTemplate;
- (void) loadHtmlResourceLocally : (NSString*)fTemplate;

- (void) registerNotifications;
- (void) removeNotifications;

- (void) handleEnteredBackground : (UIApplication *)application;
- (void) handleEnteredForeground : (UIApplication *)application;

- (void) saveCurrentPage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self registerNotifications];
    [self loadHtmlStringLocally: strApisFile];
}

- (void)viewWillUnload{
    [self removeNotifications];
}

#pragma mark - notification center
- (void) registerNotifications{
    // desc - register the notification center events
    // see 1, http://stackoverflow.com/questions/4846822/iphone-use-of-background-foreground-methods-in-appdelegate
    //     2, http://stackoverflow.com/questions/5410667/nsnotificationcenter-code-works-in-iphone-but-not-on-ipad
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void) removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
}

// desc - remember current page and persisted into sqllite
- (void) handleEnteredBackground : (UIApplication *)application{
#ifdef DEBUG
    NSLog(@"background - on %d page of ebook", [DataModelStore defaultStore].iCurrentPage);
#endif
    [self saveCurrentPage];
}

- (void) saveCurrentPage{
    // desc - guess current page for http://stackoverflow.com/questions/992348/reading-html-content-from-a-uiwebview, with detection bug
    NSString* strRetValue = [self->webview stringByEvaluatingJavaScriptFromString:@"viewerCurrentPage();"];
    if ([strRetValue length] != 0) {
        if ([DataModelStore defaultStore].iCurrentPage != [strRetValue intValue]) {
            [[DataModelStore defaultStore] savePageNumber:[strRetValue intValue] callback:^(BOOL success) {
                NSLog(@"current persisted page number : %d", [DataModelStore defaultStore].iCurrentPage);
            }];
        }
    }
}

// desc - reload current page with refreshment
- (void) handleEnteredForeground : (UIApplication *)application{
#ifdef DEBUG
    NSLog(@"foreground - on %d page of ebook", [DataModelStore defaultStore].iCurrentPage);
#endif
}

// desc - load html via String in UIWebContainer - not used now
- (void) loadHtmlResourceLocally : (NSString*)fTemplate{
    NSString* path = [[NSBundle mainBundle]pathForResource:fTemplate ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* req = [[NSURLRequest alloc]initWithURL:url];
    [self->webview loadRequest:req];
}

// desc - load html via String in UIWebContainer - not used now
// requirements :
//      1, need to adjust for UIContainer to UI status
//      2, need to add UI status refreshment
// issue - how-to split the logic into background quene and main thread queue
- (void) loadHtmlStringLocally : (NSString*)fTemplate{
    NSString* path = [[NSBundle mainBundle]pathForResource:fTemplate ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSError* error = nil;
    NSString* strWebContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    // desc - replace string with parameter, book id = hcz96jeSLe8C
    // parameters list in order - why is 100% will be replaced with 100 via %@
    // see objective-c programming of http://mustache.github.com via texttemplate similar djano in objective-c, also check up with http://code.google.com/p/djolt/source/checkout
    strWebContent = [strWebContent stringByReplacingOccurrencesOfString:@"{{id}}"
                                                             withString:strBookId];
    strWebContent = [strWebContent stringByReplacingOccurrencesOfString:@"{{pageNumber}}"
                                                             withString:[NSString stringWithFormat:@"%d", [DataModelStore defaultStore].iCurrentPage]];
    
    [self->webview sizeToFit];
    [self->webview loadHTMLString:strWebContent baseURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
#ifdef DEBUG
    NSLog(@"webview started");
#endif
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    v.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    v.tag = iUIActivityIndicatorId;
    [self.view addSubview:v];
    [v startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
#ifdef DEBUG
    NSLog(@"webview finished");
#endif
    [[self.view viewWithTag:iUIActivityIndicatorId] removeFromSuperview];
}

- (void)        webView:(UIWebView *)webView
   didFailLoadWithError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"failed");
#endif
}

- (BOOL)            webView:(UIWebView *)webView
 shouldStartLoadWithRequest:(NSURLRequest *)request
             navigationType:(UIWebViewNavigationType)navigationType{
#ifdef DEBUG
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSLog(@"navigation - UIWebViewNavigationTypeLinkClicked");
    }
    else if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"navigation - UIWebViewNavigationTypeFormSubmitted");
    }
    else if (navigationType == UIWebViewNavigationTypeBackForward) {
        NSLog(@"navigation - UIWebViewNavigationTypeBackForward");
    }
    else if (navigationType == UIWebViewNavigationTypeReload) {
        NSLog(@"navigation - UIWebViewNavigationTypeReload");
    }
    else if (navigationType == UIWebViewNavigationTypeFormResubmitted) {
        NSLog(@"navigation - UIWebViewNavigationTypeFormResubmitted");
    }
    else if (navigationType == UIWebViewNavigationTypeOther) {
        // desc - only valid for navigation done
        NSLog(@"navigation - UIWebViewNavigationTypeOther");
    }
#endif
    return (YES);
}

@end
