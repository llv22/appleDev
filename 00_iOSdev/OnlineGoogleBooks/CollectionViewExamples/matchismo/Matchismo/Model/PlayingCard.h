//
//  PlayingCard.h
//  Matchismo
//
//  Created by Simon Fairbairn on 07/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSArray *)rankStrings;
+(NSUInteger) maxRank;

@end
