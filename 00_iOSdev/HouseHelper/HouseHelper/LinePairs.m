//
//  LinePairs.m
//  HouseHelper
//
//  Created by Ding Orlando on 12/15/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "LinePairs.h"

@implementation LinePairs

// TODO : http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1
- (id)initWithLine:(NSString*)line
      withLineView:(NSString*)lineView
      withColorInt:(int)intLine
     withTotalLine:(int)totalLine{
    self = [super init];
    if (self) {
        self->_gLine = line;
        self->_gLineView = lineView;
        self->_iColorLine = intLine;
        self->_iTotalLine = totalLine;
    }
    return (self);
}

- (UIColor*)getColorLine{
//    double _dRed = self->_iColorLine / self->_iTotalLine;
//    double _dGreen = 1 - _dRed;
//    UIColor* _cColor = [UIColor colorWithRed:_dRed green:_dGreen blue:0.0 alpha:1.0];
    UIColor* _cColor =  nil;
    switch (self->_iColorLine) {
        case 3:
            _cColor = [UIColor darkGrayColor];
            break;
        case 4:
            _cColor = [UIColor blueColor];
            break;
        case 5:
            _cColor = [UIColor magentaColor];
            break;
        default:
            _cColor = [UIColor purpleColor];
            break;
    }
    return _cColor;
}

@end
