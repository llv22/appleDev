//
//  Person.m
//  08_RaiseMan
//
//  Created by Ding Orlando on 10/20/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize personName, expectedRaise;

- (id)init{
    self = [super init];
    if (self) {
        self->expectedRaise = 0.05;
        self->personName = @"New Person";
    }
    return (self);
}

// TODO : 2012-10-21 10:26:05.433 08_RaiseMan[969:303] [<Person 0x10057a190> setNilValueForKey]:
//          could not set nil as the value for the key expectedRaise.
// Solution : Overwrite NSObject Key-Value Path
- (void)setNilValueForKey:(NSString *)key{
    if ([key isEqual:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    }
    else{
        [super setNilValueForKey:key];
    }
}

// TODO : write into coder
- (void)encodeWithCoder:(NSCoder *)coder{
//    desc - NSObject's encodeWithCoder doesn't exist
//    [super encodeWithCoder:coder];
    [coder encodeObject:self->personName forKey:@"personName"];
    [coder encodeFloat:self->expectedRaise forKey:@"expectedRaise"];
}

- (id)initWithCoder:(NSCoder *)coder{
//    desc - NSObject's initWithCoder doesn't exist
//    [super initWithCoder:coder];
    self = [super init];
    if (self) {
        self->personName = [coder decodeObjectForKey:@"personName"];
        self->expectedRaise = [coder decodeFloatForKey:@"expectedRaise"];
    }
    return (self);
}

@end
