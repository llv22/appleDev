//
//  ViewController.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

enum EntityType {
    MetroStopType = 0,
    HousingType = 1
    };

@interface ViewController : UIViewController<MKMapViewDelegate, UIPopoverControllerDelegate>{
    // desc - map
    IBOutlet MKMapView* map;
    // desc - screen section
    double distNorthToSouth;
    double distEastToWest;
    
    NSMutableDictionary* gLines;
}

@property (nonatomic, strong) UIPopoverController* currentPopover;
@property (nonatomic, retain) MKAnnotationView* currentpopoverAnnotationView;

- (IBAction)resetToCenter:(id)sender;

@end
