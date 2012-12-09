//
//  ColorPickerController.h
//  19_SViewController
//
//  Created by Ding Orlando on 10/8/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPickerDelegate;

@interface ColorPickerController : UIViewController

@property (nonatomic, assign) id<ColorPickerDelegate> delegate;
- (IBAction)doDismissal:(id)sender;

@end

@protocol ColorPickerDelegate <NSObject>

//color == nil on cancel
- (void) colorPicker:(ColorPickerController*)picker
    didSetColorNamed:(NSString*)theName
             toColor:(UIColor*)theColor;

@end
