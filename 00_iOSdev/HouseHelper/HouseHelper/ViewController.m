//
//  ViewController.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void) resetToSquare;

@end

@implementation ViewController

- (id)init{
    self = [super init];
    if (self) {
        self->distNorthToSouth = 8000;
        self->distEastToWest = 5000;
    }
    return (self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // desc - located into chengdu central
    [self resetToSquare];
}

- (void) resetToSquare{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(30.657665, 104.065719);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, self->distNorthToSouth, self->distEastToWest);
    [self->map setRegion:region animated:YES];
}

- (IBAction)resetToCenter:(id)sender{
    [self resetToSquare];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
