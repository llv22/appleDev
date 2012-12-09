//
//  IndexViewController.m
//  19_SViewController
//
//  Created by Ding Orlando on 10/5/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)notifyback:(id)sender{
    NSDictionary *d = @{@"color":@"orlando", @"pic":@"I'm right!"};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goPic"
                                                       object:self
                                                     userInfo:d];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
