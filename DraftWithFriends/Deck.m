//
//  Deck.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
    @property (nonatomic, readwrite) NSMutableArray *cardsInDeck;
@end

@implementation Deck

+ (Deck *)initializeDeck
{
    Deck *deck = [[Deck alloc] init];
    
    [deck setCardsInDeck:[[NSMutableArray alloc] initWithArray:@[]]];
    
    return deck;
}

@end
