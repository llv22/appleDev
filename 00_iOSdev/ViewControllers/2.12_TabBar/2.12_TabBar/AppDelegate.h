//
//  AppDelegate.h
//  2.12_TabBar
//
//  Created by Ding Orlando on 10/4/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewController;
@class SecondViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FirstViewController *firstViewController;
@property (strong, nonatomic) UINavigationController *firstNavigationController;
@property (strong, nonatomic) SecondViewController *secondViewController;
@property (strong, nonatomic) UINavigationController *secondNavigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
