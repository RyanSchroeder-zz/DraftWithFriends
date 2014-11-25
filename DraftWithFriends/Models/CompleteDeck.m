//
//  CompleteDeck.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "CompleteDeck.h"

@interface CompleteDeck ()

@end

@implementation CompleteDeck

- (NSArray *)colors
{
    if (_colors) {
        return _colors;
    }
    
    NSMutableSet *colors = [NSMutableSet new];
    
    for (Card *card in self.cards) {
        [colors addObjectsFromArray:card.colors];
    }
    
    NSMutableArray *colorsArray = [NSMutableArray new];
    for (NSString *color in colors) {
        [colorsArray addObject:color];
    }
    
    return [colorsArray copy];
}

- (NSNumber *)averageCMC
{
    if (_averageCMC) {
        return _averageCMC;
    }
    
    CGFloat totalCMC = 0;
    
    for (Card *card in self.cards) {
        totalCMC += card.convertedManaCost;
    }
    
    CGFloat averageCMC = totalCMC / self.cards.count;
    return @(averageCMC);
}

@end
