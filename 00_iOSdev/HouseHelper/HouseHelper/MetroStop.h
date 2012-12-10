//
//  MetroStop.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/10/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetroStop : NSObject

@property double loc;
@property double lat;
@property (strong) NSString* stopName;

- (id)initWithLoc:(double)loc
          withLat:(double)lat
     withStopName:(NSString*)stop;

@end
