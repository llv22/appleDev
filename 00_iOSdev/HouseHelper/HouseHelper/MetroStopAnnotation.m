//
//  StopAnnotation.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/10/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "MetroStopAnnotation.h"

@implementation MetroStopAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)coord
          withStopName:(NSString*)stopName{
    self = [super init];
    if (self) {
        self->_coordinate = coord;
        self->_stopName = stopName;
    }
    return self;
}

-(NSString*)title{
    return self->_stopName;
}

@end
