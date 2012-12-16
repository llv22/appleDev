//
//  HouseBase.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "HouseBase.h"

@implementation HouseBase

- (id)initWithLoc:(double)loc
          withLat:(double)lat
    withHouseName:(NSString*)house{
    self = [super init];
    if (self) {
        self.loc = loc;
        self.lat = lat;
        self->_houseName = house;
    }
    return (self);
}

- (NSString*)description{
    return [NSString stringWithFormat:@"%f:%f - %@", self.lat, self.loc, self->_houseName];
}

@end
