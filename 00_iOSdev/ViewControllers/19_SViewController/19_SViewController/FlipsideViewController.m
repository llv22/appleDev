//
//  FlipsideViewController.m
//  19_SViewController
//
//  Created by Ding Orlando on 10/5/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)doDismiss:(id)sender{
    //desc - not self.presentedViewController
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^(void){
                                                          NSLog(@"dismissal presetation ui");
    }];
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
