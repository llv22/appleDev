//
//  StopAnnotation.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/10/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MetroStopAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* stopName;
@property (nonatomic, readonly) NSString* lineNumber;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
          withStopName:(NSString*)stopName
        withLineNumber:(NSString*)lineNumber;

@end
