//
//  AppDelegate.m
//  19_SViewController
//
//  Created by Ding Orlando on 10/3/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//
//  1, so in page 441, you can refer to rootviewController via [[UIApplication sharedApplication]keyWindow]rootViewController] for root
//

#import "AppDelegate.h"
#import "RootViewController.h"

//#define LOADSUBVIEW 0
#define LOADROOT 1
//#define ManVCManView 0
#define ManVCNibView 1
//#define RVNib 2
#define UpShfitRootView 2

@interface AppDelegate()

-(void)AddSubViewDirectly:(RootViewController*)theRVC;
-(void)AddRootViewControllerDirectly:(RootViewController*)theRVC;
-(void)AssertTheSame;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
#ifdef ManVCNibView
    RootViewController* theRVC = [[RootViewController alloc]initWithNibName:@"MyNib" bundle:nil];
#else
    RootViewController* theRVC = [[RootViewController alloc]init];
#endif
    
#ifdef LOADSUBVIEW
    //desc - to add item directly via addsubview
    [self AddSubViewDirectly:theRVC];
#elif LOADROOT
    //desc - to add item directly via rootcontroller
    [self AddRootViewControllerDirectly:theRVC];
#endif
    self.window.backgroundColor = [UIColor redColor];
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(AssertTheSame) withObject:nil afterDelay:1.0f];
    return YES;
}

-(void)AddSubViewDirectly:(RootViewController*)theRVC{
    self.rvc = theRVC;
    //    [theRVC release];
    [self.window addSubview:self.rvc.view];
}

-(void)AddRootViewControllerDirectly:(RootViewController*)theRVC{
#ifdef UpShfitRootView
    //desc - Programming iOS [Up-Shifted Root View]
    [self.window addSubview:theRVC.view];
#else
    self.window.rootViewController = theRVC;
#endif
    self.rvc = theRVC;
    //    [theRVC release];
}

-(void)AssertTheSame{
#ifndef UpShfitRootView
    //desc - self.window.rootViewController = theRVC; should be set rootViewController, not just addSubView
    UIViewController *rvc = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    NSAssert(rvc == self.rvc, @"sharedApplication->keyWindow->rootViewController should be equal with self.rvc for reference");
#endif
}

-(void)AddRootViewControllerDirectly{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
