//
//  MTGSet.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface MTGSet : NSObject


@property (nonatomic, readonly) NSString *setCode;
@property (nonatomic, readonly) NSArray *cardsInSet;

+ (MTGSet *)setWithCards:(NSArray *)cards
                 setCode:(NSString *)setCode;

- (NSArray *)mythicRares;
- (NSArray *)rares;
- (NSArray *)uncommons;
- (NSArray *)commons;
- (NSArray *)basicLands;
- (Card *)cardWithNumber:(NSString *)number;

- (NSArray *)generateBoosterPack;
- (NSArray *)generateBoosterPackMinus:(NSInteger)numPicked;

@end
