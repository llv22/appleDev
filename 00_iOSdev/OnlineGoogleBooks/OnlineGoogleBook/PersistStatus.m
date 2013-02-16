//
//  PersistStatus.m
//  OnlineGBooks
//
//  Created by Ding Orlando on 2/13/13.
//  Copyright (c) 2013 Ding Orlando. All rights reserved.
//

#import "PersistStatus.h"

@implementation PersistStatus

// desc - for xcdatamodeld should be @dynamic, persisted model should be synchronized here
@dynamic iCurrentPage;

- (void)awakeFromFetch
{
    [super awakeFromFetch];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
}

@end
