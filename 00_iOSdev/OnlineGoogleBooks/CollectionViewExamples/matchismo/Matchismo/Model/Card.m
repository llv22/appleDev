//
//  Card.m
//  Matchismo
//
//  Created by Simon Fairbairn on 07/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "Card.h"

@implementation Card


- (int)match:(NSArray *)otherCards {
    int score = 0;
    for ( Card *card in otherCards ) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end


