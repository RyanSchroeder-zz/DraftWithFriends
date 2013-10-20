//
//  Deck.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deck : NSObject

@property (nonatomic, readonly) NSMutableArray *cardsInDeck;

+ (Deck *)initializeDeck;

@end
