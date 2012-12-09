//
//  ViewController.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController{
    IBOutlet MKMapView* map;
    double distNorthToSouth;
    double distEastToWest;
}

- (IBAction)resetToCenter:(id)sender;

@end
