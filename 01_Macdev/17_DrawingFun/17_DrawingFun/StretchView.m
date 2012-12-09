//
//  StretchView.m
//  17_DrawingFun
//
//  Created by Ding Orlando on 12/9/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "StretchView.h"

@interface StretchView()

- (NSColor*) getCurrentColor;

@end

@implementation StretchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        srandom((unsigned)time(NULL));
        self->path = [NSBezierPath bezierPath];
        [self->path setLineWidth:3.0];
        NSPoint p = [self randomPoint];
        [self->path moveToPoint:p];
        for (int i= 0; i < 15; i++) {
            p = [self randomPoint];
            [self->path lineToPoint:p];
        }
        [self->path closePath];
    }
    return self;
}

// TODO : generate random point
- (NSPoint)randomPoint{
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return (result);
}

#pragma mark - redraw frame content
- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect bounds = [self bounds];
    [[self getCurrentColor]set];
    [NSBezierPath fillRect:bounds];
    [[NSColor whiteColor]set];
    // desc - linked point to line
//    [path stroke];
    [self->path fill];
}

#pragma mark - redraw section
- (void)redrawCustomView: (id)sender{
//    [self setNeedsDisplay:YES];
    // desc - explict redrawn UIView rect
    NSRect diryRect  = [self bounds];
    NSSize newScale;
    newScale.width = 0.9;
    newScale.height = 0.9;
    [self scaleUnitSquareToSize:newScale];
    [self setNeedsDisplayInRect:diryRect];
}

- (NSColor*) getCurrentColor{
    if(!self->color){
        self->color = [NSColor greenColor];
    }
    else{
        if (self->color == [NSColor greenColor]) {
            self->color = [NSColor redColor];
        }
        else{
            self->color = [NSColor greenColor];
        }
    }
    return (self->color);
}

#pragma mark - flipper
- (BOOL) isFlipped{
    return (YES);
}

@end
