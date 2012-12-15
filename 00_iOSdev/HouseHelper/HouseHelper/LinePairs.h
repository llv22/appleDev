//
//  LinePairs.h
//  HouseHelper
//
//  Created by Ding Orlando on 12/15/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinePairs : NSObject{
    int _iColorLine;
    double _iTotalLine;
}

@property (nonatomic, readonly) NSString* gLine;
@property (nonatomic, readonly) NSString* gLineView;
@property (nonatomic, getter = getColorLine) UIColor* colorLine;

- (id)initWithLine:(NSString*)line
      withLineView:(NSString*)lineView
      withColorInt:(int)intLine
     withTotalLine:(int)totalLine;

@end
