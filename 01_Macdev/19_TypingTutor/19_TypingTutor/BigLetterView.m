//
//  BigLetterView.m
//  19_TypingTutor
//
//  Created by ding orlando on 1/18/13.
//  Copyright (c) 2013 ding orlando. All rights reserved.
//

#import "BigLetterView.h"

@implementation BigLetterView

//@synthesize bgColor = bgColor, string = string;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSLog(@"initializing view");
        bgColor = [NSColor yellowColor];
        string = @"";
    }
    
    return self;
}

#pragma mark - Accessor
- (void) setBgColor:(NSColor *)c{
    self->bgColor = c;
    [self setNeedsDisplay:YES];
}

- (NSColor*)bgColor{
    return self->bgColor;
}

- (void)setString:(NSString *)c{
    self->string = c;
    NSLog(@"The string is now %@", c);
}

- (NSString*)string{
    return self->string;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect bounds = [self bounds];
    [self->bgColor set];
    [NSBezierPath fillRect:bounds];
    
    if ([[self window] firstResponder] == self &&
        [NSGraphicsContext currentContextDrawingToScreen] //?
        ) {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        [NSBezierPath fillRect:bounds];
        [NSGraphicsContext restoreGraphicsState];
//        [[NSColor keyboardFocusIndicatorColor] set];
//        [NSBezierPath setDefaultLineWidth:4.0];
//        [NSBezierPath strokeRect:bounds];
    }
}

- (BOOL)isOpaque{
    return YES;
}

#pragma mark - hook for first responser
- (BOOL) acceptsFirstResponder{
    NSLog(@"Accepting");
    return YES;
}

- (BOOL) resignFirstResponder{
    NSLog(@"Resigning");
//    [self setNeedsDisplay:YES];
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}

- (BOOL) becomeFirstResponder{
    NSLog(@"Becoming");
    [self setNeedsDisplay:YES];
    return YES;
}

#pragma mark - key events

- (void)keyDown:(NSEvent *)theEvent{
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertText:(id)insertString{
    [self setString:insertString];
}

- (void)insertTab:(id)sender{
    [[self window]selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender{
    [[self window]selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender{
    [self setString:@""];
}

#pragma mark - view movement

- (void) viewDidMoveToWindow{
    int options = NSTrackingMouseEnteredAndExited |
                    NSTrackingActiveAlways |
                    NSTrackingInVisibleRect;
    
    NSTrackingArea *ta = [[NSTrackingArea alloc]initWithRect:NSZeroRect
                                                     options:options
                                                       owner:self
                                                    userInfo:nil];
    [self addTrackingArea:ta];
}

- (void)mouseEntered:(NSEvent *)theEvent{
    isHighted = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent{
    isHighted = NO;
    [self setNeedsDisplay:YES];
}

@end
