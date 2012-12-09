//
//  ViewController.m
//  2.14_UITextField
//
//  Created by Ding Orlando on 10/4/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

// desc - http://stackoverflow.com/questions/959007/files-imported-when-importing-foundation-foundation-h-for-cocoa
#import <UIKit/NSText.h>
#import "ViewController.h"

@interface ViewController ()

-(void)calculateAndDisplayTextFieldLengthWithText:(NSString*) paramText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
//    CGRect textFieldFrame = CGRectMake(38.0f, 30.0f, 200.0f, 31.0f);
    CGRect textFieldFrame = CGRectMake(0.0f, 0.0f, 200.0f, 31.0f);
    self.myTextField = [[UITextField alloc]initWithFrame:textFieldFrame];
    self.myTextField.delegate = self;
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // desc - UITextAlignmentCenter deprecated in iOS 6.0, see reference of iOS 6.0
    self.myTextField.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter;
    self.myTextField.placeholder = @"Enter text here...";
    self.myTextField.text = @"Sir Richard Branson";
    // desc - centered the myTextField
    self.myTextField.center = CGPointMake(self.view.center.x, self.view.center.y/2);
    // desc - leftView, rightView
    UILabel *currencyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    currencyLabel.text = [[[NSNumberFormatter alloc]init]currencySymbol];
    currencyLabel.font = self.myTextField.font;
    [currencyLabel sizeToFit];
    self.myTextField.leftView = currencyLabel;
    self.myTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.myTextField];
    
    CGRect labelCounterFrame = self.myTextField.frame;
    labelCounterFrame.origin.y += textFieldFrame.size.height + 10;
    self.labelCounter = [[UILabel alloc]initWithFrame:labelCounterFrame];
    [self.view addSubview:self.labelCounter];
    
    [self calculateAndDisplayTextFieldLengthWithText:self.myTextField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calculateAndDisplayTextFieldLengthWithText:(NSString*) paramText{
    NSString *characterOrCharacters = @"Characters";
    if ([paramText length] == 1) {
        characterOrCharacters = @"Character";
    }
    self.labelCounter.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)[paramText length], characterOrCharacters];
}

#pragma UITextFieldDelegate
- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string{
    BOOL result = YES;
    
    if ([textField isEqual:self.myTextField]) {
        NSString *wholeText = [textField.text stringByReplacingCharactersInRange:range
                                                                      withString:string];
        [self calculateAndDisplayTextFieldLengthWithText:wholeText];
    }
    
    return result;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
