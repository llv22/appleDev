//
//  BKAppDelegate.h
//  BookshelfSkeleton
//
//  Created by Ding Orlando on 3/30/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKNavViewController;

@interface BKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BKNavViewController *rootViewController;
@property (strong, nonatomic) UINavigationController *navigationController;


@end
