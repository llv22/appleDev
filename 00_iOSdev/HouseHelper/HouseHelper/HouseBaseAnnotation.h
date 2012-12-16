//
//  HouseBaseAnnotation.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class HouseBase;

@interface HouseBaseAnnotation : NSObject<MKAnnotation>{
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, getter = getHouseName) NSString* houseName;
@property (nonatomic, readonly) NSString* houseBuilder;
@property (nonatomic, readonly) HouseBase* house;

- (id)initWithLocation:(HouseBase*)h
      withHouseBuilder:(NSString*)houseBuilder;

@end
