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

@interface ViewController : UIViewController<MKMapViewDelegate>{
    // desc - map
    IBOutlet MKMapView* map;
    // desc - screen section
    double distNorthToSouth;
    double distEastToWest;
    
    NSMutableDictionary* gLines;
    
    /** - filed with declaration in advance, replace with runtime intergration
     *
    // desc - data and graphic array for Metro line 2
    MKPolyline* gLine2;
    MKPolylineView* gLine2View;
    
    // desc - data and graphic array for Metro line 3
    MKPolyline* gLine3;
    MKPolylineView* gLine3View;
    
    // desc - data and graphic array for Metro line 4
    MKPolyline* gLine4;
    MKPolylineView* gLine4View;
    
    // desc - data and graphic array for Metro line 5
    MKPolyline* gLine5;
    MKPolylineView* gLine5View;
     *
     **/
}

- (IBAction)resetToCenter:(id)sender;

@end
