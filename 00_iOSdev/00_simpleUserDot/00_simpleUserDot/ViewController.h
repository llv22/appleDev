//
//  ViewController.h
//  00_simpleUserDot
//
//  Created by Ding Orlando on 9/16/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    IBOutlet UIView* upViewContainer;
    IBOutlet UIToolbar* bottomToolbar;
}

-(IBAction)buttonPressed:(id)sender;

@end
