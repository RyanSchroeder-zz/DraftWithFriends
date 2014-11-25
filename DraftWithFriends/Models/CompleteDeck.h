//
//  CompleteDeck.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CompleteDeck : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) Card *featuredCard;
@property (nonatomic) NSString *draftedBy;
@property (nonatomic) NSArray *cards;
@property (nonatomic) NSArray *colors;
@property (nonatomic) NSNumber *averageCMC;
@property (nonatomic) NSDate *dateDrafted;

@end
