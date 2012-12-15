//
//  HouseBaseAnnotation.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HouseBaseAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* houseName;
@property (nonatomic, readonly) NSString* houseBuilder;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
         withHouseName:(NSString*)houseName
      withHouseBuilder:(NSString*)houseBuilder;

@end
