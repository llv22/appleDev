//
//  HouseBaseAnnotation.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "HouseBaseAnnotation.h"

@implementation HouseBaseAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord
         withHouseName:(NSString*)houseName
      withHouseBuilder:(NSString*)houseBuilder{
    self = [super init];
    if (self) {
        self->_coordinate = coord;
        self->_houseName = houseName;
        self->_houseBuilder = houseBuilder;
    }
    return self;
}

-(NSString*)title{
    return self->_houseName;
}

-(NSString*)subtitle{
    return self->_houseBuilder;
}

@end
