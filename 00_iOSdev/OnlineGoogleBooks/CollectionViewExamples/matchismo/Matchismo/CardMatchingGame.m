//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Simon Fairbairn on 08/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;

@property (nonatomic, readwrite) int score;
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards {
    if ( !_cards ) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    if ( self ) {
        for ( int i = 0; i < cardCount; i++ ) {
            Card *card = [deck drawRandomCard];
            if ( !card ) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

-(PlayingCard *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(int)numberOfMatches {
    if (!_numberOfMatches) _numberOfMatches = 2;
    return _numberOfMatches;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
-(void)flipCardAtIndex:(NSUInteger)index {
    
    
    PlayingCard *card = [self cardAtIndex:index];
    
    // Message of last game action is stored as a string
    // (think of it like a description method but instead of for a class,
    // it's for a game action)
    // Actual display of message is handled by controller
    // Arguable that the phrasing of the message is actually
    // a controller responsibility, but I think the overhead
    // in implementing it that way isn't worth the cost.
    
    NSString *message = [NSString stringWithFormat:@"Flipped up %@", card.contents];
    
    if ( !card.isUnplayable ) {
        if ( !card.isFaceUp ) {
            
            // An array array of all the potential cards
            NSMutableArray *potentialCards = [[NSMutableArray alloc] init];
            [potentialCards addObject:card];
            for ( Card *otherCard in self.cards ) {
                // check the other cards
                if ( otherCard.isFaceUp && !otherCard.isUnplayable ) {
                    [potentialCards addObject:otherCard];
                }
            }
            // If our array of cards is the same as the number of matches
            // It's time to do the check
            if ( potentialCards.count == self.numberOfMatches ) {
                // Make a copy for later
                NSArray *cardsCopy = [potentialCards copy];
                int matchScore = 0;
                NSMutableArray *matchStrings = [[NSMutableArray alloc] init];
                
                // Recursive loop through the potential matches
                while ( [potentialCards lastObject] ) {
                    // Pop the stack
                    PlayingCard *theCard = [potentialCards lastObject];
                    [potentialCards removeLastObject];
                    
                    // Do the work on the rest of the cards
                    [matchStrings addObject:theCard.contents];
                    matchScore += [theCard match:potentialCards];

                }
                // If we've got a match,
                // let's make them all unplayable and grab the score
                if ( matchScore ) {
                    for ( PlayingCard *card in cardsCopy ) {
                        card.unplayable = YES;
                        card.unplayable = YES;
                    }
                    self.score += matchScore * MATCH_BONUS;
                    
                } else {
                    for ( PlayingCard *card in cardsCopy ) {
                        card.faceUp = NO;
                    }
                    self.score -= MISMATCH_PENALTY;
                }
            
                // We now have an array of strings
                NSString *matchString = [matchStrings componentsJoinedByString:@" and "];
                if ( matchScore ) {
                    message = [NSString stringWithFormat:@"Matched %@ for %d points!", matchString, matchScore * MATCH_BONUS];
                } else {
                    message = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", matchString, MISMATCH_PENALTY];
                }
                
            }
            
            self.score -= FLIP_COST;
        }
        
        card.faceUp = !card.isFaceUp;
        
    }
    self.message = message;
}





-(void)deal {
    
}

@end
