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
const int iUIActivityIndicatorId = 1001;

@interface ViewController ()

- (void) loadHtmlStringLocally : (NSString*)fTemplate;
- (void) loadHtmlResourceLocally : (NSString*)fTemplate;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadHtmlStringLocally: strApisFile];
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
- (void) loadHtmlStringLocally : (NSString*)fTemplate{
    NSString* path = [[NSBundle mainBundle]pathForResource:fTemplate ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSError* error = nil;
    NSString* strWebContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    // desc - replace string with parameter, book id = hcz96jeSLe8C
    // parameters list in order - why is 100% will be replaced with 100 via %@
    // see objective-c programming of http://mustache.github.com via texttemplate similar djano in objective-c, also check up with http://code.google.com/p/djolt/source/checkout
    // strWebContent = [NSString stringWithFormat:strWebContent, @"hcz96jeSLe8C"];
    strWebContent = [strWebContent stringByReplacingOccurrencesOfString:@"{{id}}" withString:@"hcz96jeSLe8C"];
    
    /**
     * desc - replacement of string content https://github.com/groue/GRMustache
     * desc - replace with UI size, http://stackoverflow.com/questions/668228/string-replacement-in-objective-c
    int iViewWidth = self->webview.frame.size.width, iViewHeight = self->webview.frame.size.height;
    strWebContent = [strWebContent stringByReplacingOccurrencesOfString:@"$width$" withString:[NSString stringWithFormat:@"%d", iViewWidth]];
    strWebContent = [strWebContent stringByReplacingOccurrencesOfString:@"$height$" withString:[NSString stringWithFormat:@"%d", iViewHeight]];
     **/
    
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
    NSLog(@"started");
#endif
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    v.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    v.tag = iUIActivityIndicatorId;
    [self.view addSubview:v];
    [v startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
#ifdef DEBUG
    NSLog(@"finished");
#endif
    [[self.view viewWithTag:iUIActivityIndicatorId] removeFromSuperview];
    /**
     * status of page range
     *
    [[DataModelStore defaultStore] savePageNumber:1 callback:^(BOOL success) {
        NSLog(@"save page status : %d", success);
        NSLog(@"current persisted page number : %d", [DataModelStore defaultStore].iCurrentPage);
    }];
     *
     **/
}

- (void)        webView:(UIWebView *)webView
   didFailLoadWithError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"failed");
#endif
}

@end
