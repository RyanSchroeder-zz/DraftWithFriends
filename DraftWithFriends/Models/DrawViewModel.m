//
//  DrawViewModel.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DrawViewModel.h"

#define FULL_HAND_OF_CARDS 7

@implementation DrawViewModel

- (NSMutableArray *)cardsInLibrary
{
    if (!_cardsInLibrary) {
        _cardsInLibrary = [NSMutableArray new];
    }
    
    return _cardsInLibrary;
}

- (NSMutableArray *)cardsDrawn
{
    if (!_cardsDrawn) {
        _cardsDrawn = [NSMutableArray new];
    }
    
    return _cardsDrawn;
}

- (NSMutableArray *)cardsPlayed
{
    if (!_cardsPlayed) {
        _cardsPlayed = [NSMutableArray new];
    }
    
    return _cardsPlayed;
}

- (void)drawHand
{
    for (NSInteger i = 0; i < FULL_HAND_OF_CARDS; i++) {
        NSInteger randomCardIndex = arc4random_uniform(self.cardsInLibrary.count);
        [self.cardsDrawn addObject:self.cardsInLibrary[randomCardIndex]];
        [self.cardsInLibrary removeObjectAtIndex:randomCardIndex];
    }
}

- (void)drawCard
{
    NSInteger randomCardIndex = arc4random_uniform(self.cardsInLibrary.count);
    [self.cardsDrawn addObject:self.cardsInLibrary[randomCardIndex]];
    [self.cardsInLibrary removeObjectAtIndex:randomCardIndex];
}

@end
