//
//  Deck.h
//  Matchismo
//
//  Created by Simon Fairbairn on 07/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface Deck : NSObject

- (void) addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *) drawRandomCard;

@end
