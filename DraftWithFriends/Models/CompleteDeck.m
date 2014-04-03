//
//  CompleteDeck.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "CompleteDeck.h"
#import "DeckService.h"

@interface CompleteDeck ()

@property (nonatomic, readwrite) NSString *userId;
@property (nonatomic, readwrite) Card *featuredCard;
@property (nonatomic, readwrite) NSArray *cards;
@property (nonatomic, readwrite) NSDate *dateDrafted;

@end

@implementation CompleteDeck

- (id)initWithCards:(NSArray *)cards
       featuredCard:(Card *)card
             userId:(NSString *)userId
        dateDrafted:(NSDate *)dateDrafted
{
    self = [super init];
    
    self.cards = cards;
    self.featuredCard = card;
    self.userId = userId;
    self.dateDrafted = dateDrafted;
    
    return self;
}

- (NSArray *)colors
{
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
    CGFloat totalCMC = 0;
    
    for (Card *card in self.cards) {
        totalCMC += card.convertedManaCost;
    }
    
    CGFloat averageCMC = totalCMC / self.cards.count;
    return @(averageCMC);
}

@end
