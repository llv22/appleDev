//
//  Person.h
//  08_RaiseMan
//
//  Created by Ding Orlando on 10/20/12.
//  Copyright (c) 2012 Ding Orlando. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO : chapter 10
@interface Person : NSObject<NSCoding>{
    NSString *personName;
    float expectedRaise;
}

@property(readwrite, copy) NSString *personName;
@property(readwrite) float expectedRaise;

@end
