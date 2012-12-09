//
//  StretchView.h
//  17_DrawingFun
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView{
    NSColor* color;
    NSBezierPath* path;
}

- (IBAction)redrawCustomView: (id)sender;
- (NSPoint)randomPoint;

@end
