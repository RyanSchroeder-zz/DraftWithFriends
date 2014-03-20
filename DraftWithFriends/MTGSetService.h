//
//  MTGSetService.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGSet.h"
#import "Card.h"

typedef void(^ServiceCallback)(NSError *error, id successObject);

typedef NS_ENUM(NSUInteger, LandType) {
    LandSwamp = 0,
    LandMountain = 1,
    LandPlains = 2,
    LandIsland = 3,
    LandForest = 4
};

@interface MTGSetService : NSObject

+ (MTGSetService *)sharedService;

- (void)setWithSetCode:(NSString *)setCode
              callback:(ServiceCallback)callback;
- (NSInteger)boosterPackSize;

- (Card *)cardWithSetCode:(NSString *)setCode andNumber:(NSString *)number;
- (NSArray *)landType:(LandType)landType withCount:(NSInteger)count;

@end
