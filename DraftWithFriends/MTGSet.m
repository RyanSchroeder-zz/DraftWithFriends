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
@end

@implementation MTGSet

+ (MTGSet *)setWithCards:(NSArray *)cards
{
    MTGSet *instance = [[MTGSet alloc] init];
    
    [instance setCardsInSet:cards];
    
    return instance;
}

@end
