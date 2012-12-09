//
//  RootViewController.m
//  2.7_SingleViewController
//
//  Created by Ding Orlando on 10/2/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"

@interface RootViewController ()

-(void)pushSecondController;

@end

@implementation RootViewController

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
	// Do any additional setup after loading the view - green
    self.view.backgroundColor = [UIColor colorWithRed:0 green:.5 blue:.6 alpha:1];
    self.title = @"First Controller";
}


-(void)pushSecondController{
    SecondViewController *secondController = [[SecondViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:secondController animated:YES];
}

//TODO : push view into navigation stack
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self performSelector:@selector(pushSecondController) withObject:nil afterDelay:5.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
