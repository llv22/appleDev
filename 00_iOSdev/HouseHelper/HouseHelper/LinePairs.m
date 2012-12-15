//
//  LinePairs.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/15/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "LinePairs.h"

@implementation LinePairs

- (id)initWithLine:(NSString*)line
      withLineView:(NSString*)lineView{
    self = [super init];
    if (self) {
        self->_gLine = line;
        self->_gLineView = lineView;
    }
    return (self);
}

@end
