//
//  CompleteDeck+Mapper.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "CompleteDeck+Mapper.h"

@implementation CompleteDeck (Mapper)

+ (NSArray *)mapPFCompleteDeckArray:(NSArray *)pfDecks
{
    NSMutableArray *decks = [NSMutableArray new];
    
    for (PFObject *pfDeck in pfDecks) {
        if (pfDeck) [decks addObject:[self mapPFCompleteDeck:pfDeck]];
    }
    
    return [decks copy];
}

+ (CompleteDeck *)mapPFCompleteDeck:(PFObject *)pfDeck
{
    if (!pfDeck) return nil;
    
    CompleteDeck *deck = [CompleteDeck new];
    
#warning Possibly bad implementation
    deck.userId = pfDeck[@"userId"];
    deck.featuredCard = pfDeck[@"featuredCard"];
    deck.cards = pfDeck[@"cards"];
    deck.colors = pfDeck[@"colors"];
    deck.averageCMC = pfDeck[@"averageCMC"];
    deck.dateDrafted = pfDeck.createdAt;
    
    return deck;
}

@end
