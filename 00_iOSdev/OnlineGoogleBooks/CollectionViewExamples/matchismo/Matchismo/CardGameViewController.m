//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Simon Fairbairn on 07/02/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameControl;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController


- (IBAction)deal:(id)sender {
    self.flipCount = 0;
    self.resultsLabel.text = @"";
    self.game = nil;
    self.gameControl.enabled = YES;
    [self updateUI];
    
}

-(CardMatchingGame *)game {
    if ( !_game ) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}


-(void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void) updateUI {
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack.png"];
    [cardBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];

        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
		[cardButton setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
		[cardButton setImage:[[UIImage alloc] init] forState:UIControlStateDisabled|UIControlStateSelected];
        

        
        
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.resultsLabel.text = self.game.message;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


-(void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    // Is this the first flip of a new game?
    if ( self.gameControl.enabled ) {
        // Disable
        self.gameControl.enabled = NO;
        // Send number of matches to game
        self.game.numberOfMatches = self.gameControl.selectedSegmentIndex + 2;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
     self.flipCount++;

    [self updateUI];
}



@end
