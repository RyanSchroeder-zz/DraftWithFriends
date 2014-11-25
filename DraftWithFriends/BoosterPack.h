//
//  BoosterPack.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoosterPack : NSObject

@property (nonatomic, readonly) NSMutableArray *cardsInBoosterPack;
@property (nonatomic, readonly) NSString *setCode;

+ (BoosterPack *)boosterPackWithCards:(NSArray *)cards
                              setCode:(NSString *)setCode;

@end
