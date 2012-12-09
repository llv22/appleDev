//
//  ColorPickerController.m
//  19_SViewController
//
//  Created by Ding Orlando on 10/8/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ColorPickerController.h"

@interface ColorPickerController ()

@end

@implementation ColorPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doDismissal:(id)sender{
    [self.delegate colorPicker:self
              didSetColorNamed:nil
                       toColor:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
