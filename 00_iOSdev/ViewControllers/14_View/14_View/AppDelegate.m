//
//  AppDelegate.m
//  14_View
//
//  Created by Ding Orlando on 10/1/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "AppDelegate.h"

//#define CASE0 0
//#define CASE1 1
#define CASE2 2

@interface AppDelegate(PrivateMethods)

-(void)layout_v1v2v3;
-(void)layout_v1v2_withInsect;
-(void)layout_v1v2_cover;

@end

@implementation AppDelegate

//TODO : Frame rendering on page 298
-(void)layout_v1v2v3{
    UIView* v1 = [[UIView alloc]initWithFrame:CGRectMake(113, 111, 132, 194)];
    //desc - white(1,4,1) or pink(1,.4,1), zindex = 0
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [[UIView alloc]initWithFrame:CGRectMake(41, 56, 132, 194)];
    //desc - yellow(5,1,0) or green(.5,1,0), zindex = 1
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    UIView* v3 = [[UIView alloc]initWithFrame:CGRectMake(43, 197, 160, 230)];
    //desc - red color, zindex = 2 / later rendered after v2
    v3.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    [self.window addSubview:v1];
    [v1 addSubview:v2];
    [self.window addSubview:v3];
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
    //    [v1 release]; [v2 release]; [v3 release]; //ARC disabled
    // CGRect f = [[UIScreen mainScreen]applicationFrame]; //render also on statusbar
}

//TODO : Bound and Center rendering on page 298 - Inset
-(void)layout_v1v2_withInsect{
    UIView* v1 = [[UIView alloc]initWithFrame:CGRectMake(113, 111, 132, 194)];
    //desc - white(1,4,1) or pink(1,.4,1), zindex = 0
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [[UIView alloc]initWithFrame:CGRectInset(v1.bounds, 10, 10)];
    //desc - yellow(5,1,0) or green(.5,1,0), zindex = 1
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    [self.window addSubview:v1];
    [v1 addSubview:v2];
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
}

//TODO : Bound and Center rendering on page 298 - cover
-(void)layout_v1v2_cover{
    UIView* v1 = [[UIView alloc]initWithFrame:CGRectMake(113, 111, 132, 194)];
    //desc - white(1,4,1) or pink(1,.4,1), zindex = 0
    v1.backgroundColor = [UIColor colorWithRed:1 green:.4 blue:1 alpha:1];
    UIView* v2 = [[UIView alloc]initWithFrame:CGRectInset(v1.bounds, 10, 10)];
    //desc - yellow(5,1,0) or green(.5,1,0), zindex = 1
    v2.backgroundColor = [UIColor colorWithRed:.5 green:1 blue:0 alpha:1];
    [self.window addSubview:v1];
    [v1 addSubview:v2];
    CGRect f = v2.bounds;
    //desc - 2 pixel * 2 pixel
    f.size.height += 16;//10 left
    f.size.width += 16;
    //desc - adjust to cover the case
    v2.bounds = f;
    self.window.backgroundColor = [UIColor blueColor];
    [self.window makeKeyAndVisible];
}

//TODO : refer to programming iOS 4 - page 300
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow* aWindow =[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window = aWindow;
#ifdef CASE0
    [self layout_v1v2v3];
#elif CASE1
    [self layout_v1v2_withInsect];
#elif CASE2
    [self layout_v1v2_cover];
#endif
    return YES;
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
