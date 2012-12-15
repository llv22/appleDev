//
//  HouseBase.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/14/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "MetroStop.h"

@interface HouseBase : MetroStop

@property (strong) NSString* houseName;

- (id)initWithLoc:(double)loc
          withLat:(double)lat
     withHouseName:(NSString*)house;

@end
