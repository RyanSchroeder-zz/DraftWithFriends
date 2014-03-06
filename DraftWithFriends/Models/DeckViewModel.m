//
//  Deck.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/5/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DeckViewModel.h"

@implementation DeckViewModel

- (NSInteger)cardSeperationCount
{
    NSInteger count = 0;
    
    if (self.blackCards.count > 0) {
        count++;
    }
    if (self.redCards.count > 0) {
        count++;
    }
    if (self.whiteCards.count > 0) {
        count++;
    }
    if (self.blueCards.count > 0) {
        count++;
    }
    if (self.greenCards.count > 0) {
        count++;
    }
    if (self.artifactCards.count > 0) {
        count++;
    }
    if (self.multiColorCards.count > 0) {
        count++;
    }
    if (self.landCards.count > 0) {
        count++;
    }
    
    return count;
}

- (NSArray *)blackCards
{
    return @[];
}

- (NSArray *)redCards
{
    return @[];
}

- (NSArray *)whiteCards
{
    return @[];
}

- (NSArray *)blueCards
{
    NSMutableArray *fetchedCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"blue%d.jpg", i + 1];
        UIImage *cardImage = [UIImage imageNamed:name];
        [fetchedCards addObject:cardImage];
    }
    
    return [fetchedCards copy];
}

- (NSArray *)greenCards
{
    NSMutableArray *fetchedCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSString *name = [NSString stringWithFormat:@"green%d.jpg", i + 1];
        UIImage *cardImage = [UIImage imageNamed:name];
        [fetchedCards addObject:cardImage];
    }
    
    return [fetchedCards copy];
}

- (NSArray *)artifactCards
{
    return @[];
}

- (NSArray *)multiColorCards
{
    return @[];
}

- (NSArray *)landCards
{
    return @[];
}

/**
 Array of card arrays. This is seperated by colors to be displayed.
 */
- (NSMutableArray *)potentialCards
{
    if (!_potentialCards) {
        _potentialCards = [NSMutableArray new];
        
        if (self.blackCards.count > 0) {
            [_potentialCards addObject:self.blackCards];
        }
        if (self.redCards.count > 0) {
            [_potentialCards addObject:self.redCards];
        }
        if (self.whiteCards.count > 0) {
            [_potentialCards addObject:self.whiteCards];
        }
        if (self.blueCards.count > 0) {
            [_potentialCards addObject:self.blueCards];
        }
        if (self.greenCards.count > 0) {
            [_potentialCards addObject:self.greenCards];
        }
        if (self.artifactCards.count > 0) {
            [_potentialCards addObject:self.artifactCards];
        }
        if (self.multiColorCards.count > 0) {
            [_potentialCards addObject:self.multiColorCards];
        }
        if (self.landCards.count > 0) {
            [_potentialCards addObject:self.landCards];
        }
    }
    
    return _potentialCards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) {
        _chosenCards = [NSMutableArray new];
    }
    
    return _chosenCards;
}

@end
