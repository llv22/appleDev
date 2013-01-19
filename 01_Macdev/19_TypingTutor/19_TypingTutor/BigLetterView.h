//
//  BigLetterView.h
//  19_TypingTutor
//
//  Created by ding orlando on 1/18/13.
//  Copyright (c) 2013 ding orlando. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView{
    NSColor *bgColor;
    NSString *string;
    BOOL isHighted;
    // desc - 20 text with attribute
    NSMutableDictionary *attributes;
}

@property(strong) NSColor* bgColor;
@property(copy) NSString* string;

- (IBAction)savePDF:(id)sender;

@end
