//
//  RootViewController.h
//  2.11_NavBarButton
//
//  Created by Ding Orlando on 10/3/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PlayStatusType {
    Continue = 0,
    Stop = 1
};

@interface RootViewController : UIViewController{
    enum PlayStatusType status;
    dispatch_source_t aTimer;
    UIProgressView *progView;
}

@end
