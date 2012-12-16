//
//  HouseBaseAnnotation.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "HouseBaseAnnotation.h"
#import "HouseBase.h"

@implementation HouseBaseAnnotation

- (id)initWithLocation:(HouseBase*)h
      withHouseBuilder:(NSString*)houseBuilder{
    self = [super init];
    if (self) {
        self->_house = h;
        self->_houseBuilder = houseBuilder;
        self->_coordinate = CLLocationCoordinate2DMake(self->_house.lat, self->_house.loc);
    }
    return self;
}

-(NSString*)title{
    return self.houseName;
}

- (NSString*) getHouseName{
    return (self->_house.houseName);
}

-(NSString*)subtitle{
    return self->_houseBuilder;
}

@end
