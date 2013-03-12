//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Simon Fairbairn on 08/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCardDeck.h"

@interface CardMatchingGame : NSObject

@property (nonatomic, readonly) int score;
@property (strong, nonatomic) NSString *message;
@property (nonatomic) int numberOfMatches;


// Designated initializer  
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck;

-(void)flipCardAtIndex:(NSUInteger)index;
-(PlayingCard *)cardAtIndex:(NSUInteger)index;
-(void) deal;

@end
