//
//  LinePairs.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/15/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinePairs : NSObject

@property (nonatomic, readonly) NSString* gLine;
@property (nonatomic, readonly) NSString* gLineView;

- (id)initWithLine:(NSString*)line
      withLineView:(NSString*)lineView;

@end
