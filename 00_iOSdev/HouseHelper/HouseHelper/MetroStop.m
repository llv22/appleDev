//
//  MetroStop.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/10/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "MetroStop.h"

@implementation MetroStop

- (id)initWithLoc:(double)loc
          withLat:(double)lat
     withStopName:(NSString*)stop{
    self = [super init];
    if (self) {
        self->_loc = loc;
        self->_lat = lat;
        self->_stopName = stop;
    }
    return (self);
}

@end
