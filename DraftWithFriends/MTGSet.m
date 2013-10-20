//
//  MTGSet.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "MTGSet.h"

@interface MTGSet ()
@property (nonatomic, readwrite) NSArray *cardsInSet;
@property (nonatomic, readwrite) NSString *setCode;
@end

@implementation MTGSet

+ (MTGSet *)setWithCards:(NSArray *)cards
                 setCode:(NSString *)setCode
{
    MTGSet *instance = [[MTGSet alloc] init];
    
    [instance setCardsInSet:cards];
    [instance setSetCode:setCode];
    
    return instance;
}

@end
