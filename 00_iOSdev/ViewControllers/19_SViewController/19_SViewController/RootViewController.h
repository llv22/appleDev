//
//  RootViewController.h
//  19_SViewController
//
//  Created by Ding Orlando on 10/3/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerController.h"

@interface RootViewController : UIViewController<ColorPickerDelegate>
//{
//   IBOutlet  UILabel* theLabel;
//}

@property (nonatomic, strong) IBOutlet UILabel *theLabel;

- (IBAction)doPresent:(id)sender;
- (IBAction)doNotify:(id)sender;
- (IBAction)doDelegate:(id)sender;

@end
