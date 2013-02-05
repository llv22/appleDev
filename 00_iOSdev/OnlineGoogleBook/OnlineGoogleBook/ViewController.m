//
//  ViewController.m
//  OnlineGoogleBook
//
//  Created by Ding Orlando on 2/5/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString* path = [[NSBundle mainBundle]pathForResource:@"iOS6core" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
//    NSURLRequest* req = [[NSURLRequest alloc]initWithURL:url];
//    [self->webview loadRequest:req];
    NSError* error = nil;
    NSString* s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    [self->webview loadHTMLString:s baseURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finished");}

- (void)        webView:(UIWebView *)webView
   didFailLoadWithError:(NSError *)error{
    NSLog(@"failed");
}

@end
