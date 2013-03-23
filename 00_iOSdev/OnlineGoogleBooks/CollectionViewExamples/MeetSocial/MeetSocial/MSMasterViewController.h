//
//  MSMasterViewController.h
//  MeetSocial
//
//  Created by Ding Orlando on 3/19/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSDetailViewController;

@interface MSMasterViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) MSDetailViewController *detailViewController;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segSearchZipOrKeyword;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segSearchGroupsOrEvents;
@property (retain, nonatomic) IBOutlet UITextField *tfSearchText;

@end
