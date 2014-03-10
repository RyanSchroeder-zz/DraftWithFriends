//
//  Deck.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/5/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DeckViewModel.h"
#import "Card.h"

@implementation DeckViewModel

- (NSArray *)picks
{
    return [_picks sortedArrayUsingComparator:^NSComparisonResult(Card *card1, Card *card2) {
        if (card1.convertedManaCost == card2.convertedManaCost) {
            return [card1.numberInSet compare:card2.numberInSet options:NSNumericSearch];
        }
        return card1.convertedManaCost > card2.convertedManaCost;
    }];
}

- (NSArray *)blackCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isBlack]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)redCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isRed]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)whiteCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isWhite]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)blueCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isBlue]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)greenCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isGreen]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)artifactCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isArtifact]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)multiColorCards
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (Card *card in self.picks) {
        if ([card isMultiColored]) {
            [cards addObject:card];
        }
    }
    
    return [cards copy];
}

- (NSArray *)landCards
{
    return @[];
}

- (NSMutableArray *)potentialCards
{
    if (!_potentialCards) {
        _potentialCards = [NSMutableArray new];
    }
    
    return _potentialCards;
}

- (NSMutableArray *)deckListCards
{
    if (!_deckListCards) {
        _deckListCards = [self.picks mutableCopy];
    }
    
    return _deckListCards;
}

/**
 Array of card arrays. This is seperated by colors to be displayed.
 */
- (NSMutableArray *)chosenCardStacks
{
    if (!_chosenCardStacks) {
        _chosenCardStacks = [NSMutableArray new];
        
        if (self.blackCards.count > 0) {
            [_chosenCardStacks addObject:self.blackCards];
        }
        if (self.redCards.count > 0) {
            [_chosenCardStacks addObject:self.redCards];
        }
        if (self.whiteCards.count > 0) {
            [_chosenCardStacks addObject:self.whiteCards];
        }
        if (self.blueCards.count > 0) {
            [_chosenCardStacks addObject:self.blueCards];
        }
        if (self.greenCards.count > 0) {
            [_chosenCardStacks addObject:self.greenCards];
        }
        if (self.artifactCards.count > 0) {
            [_chosenCardStacks addObject:self.artifactCards];
        }
        if (self.multiColorCards.count > 0) {
            [_chosenCardStacks addObject:self.multiColorCards];
        }
        if (self.landCards.count > 0) {
            [_chosenCardStacks addObject:self.landCards];
        }
    }
    
    return _chosenCardStacks;
}

@end
