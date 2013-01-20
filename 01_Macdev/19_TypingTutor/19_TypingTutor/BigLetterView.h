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
	BOOL italic;
	BOOL bold;
}

@property (strong) NSColor* bgColor;
@property (copy) NSString* string;
@property (assign, nonatomic) BOOL italic;
@property (assign, nonatomic) BOOL bold;

- (IBAction)savePDF:(id)sender;
- (void)prepareAttributes;
- (IBAction)toggleBold:(id)sender;
- (IBAction)toggleItalic:(id)sender;

@end
