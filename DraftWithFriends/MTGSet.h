//
//  MTGSet.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

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

- (NSArray *)generateBoosterPack;

@end
