//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Simon Fairbairn on 07/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "PlayingCardDeck.h"


@implementation PlayingCardDeck

- (id)init {
    self = [super init];
    
    if ( self ) {
        for ( NSString *suit in [PlayingCard validSuits] ) {
            
            for ( NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++ ) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card atTop:YES];
            }
        }
    }
    
    return self;
}

@end
