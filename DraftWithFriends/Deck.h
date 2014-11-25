//
//  Deck.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deck : NSObject

@property (nonatomic, readonly) NSMutableArray *cardsInDeck;

+ (Deck *)initializeDeck;

@end
