//
//  ViewController.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>{
    // desc - map
    IBOutlet MKMapView* map;
    // desc - screen section
    double distNorthToSouth;
    double distEastToWest;
    
    // desc - data and graphic array for Metro line 2
    NSArray* metroLine2;
    NSArray* metroGrahpicLine2;
    MKPolyline* gLine2;
    MKPolylineView* gLine2View;
}

- (IBAction)resetToCenter:(id)sender;

@end
