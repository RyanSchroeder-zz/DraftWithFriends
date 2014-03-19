//
//  CompleteDeck+Mapper.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "CompleteDeck.h"
#import <Parse/Parse.h>

@interface CompleteDeck (Mapper)

+ (NSArray *)mapPFCompleteDeckArray:(NSArray *)pfDecks;
+ (CompleteDeck *)mapPFCompleteDeck:(PFObject *)pfDeck;

@end
