//
//  CompleteDeck.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Card.h"

@interface CompleteDeck : NSObject

@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) Card *featuredCard;
@property (nonatomic, readonly) NSArray *cards;
@property (nonatomic, readonly) NSArray *colors;
@property (nonatomic, readonly) NSNumber *averageCMC;
@property (nonatomic, readonly) NSDate *dateDrafted;
@property (nonatomic) PFObject *pfCompletedDeck;

- (id)initWithCards:(NSArray *)cards
       featuredCard:(Card *)card
             userId:(NSString *)userId
        dateDrafted:(NSDate *)dateDrafted;

@end
