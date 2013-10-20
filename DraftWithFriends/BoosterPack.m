//
//  BoosterPack.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "BoosterPack.h"

@interface BoosterPack ()

@property (nonatomic, readwrite) NSMutableArray *cardsInBoosterPack;
@property (nonatomic, readwrite) NSString *setCode;

@end

@implementation BoosterPack

+ (BoosterPack *)boosterPackWithCards:(NSArray *)cards
                              setCode:(NSString *)setCode
{
    BoosterPack *boosterPack = [[BoosterPack alloc] init];
    
    [boosterPack setCardsInBoosterPack:[NSMutableArray arrayWithArray:cards]];
    [boosterPack setSetCode:setCode];
    
    return boosterPack;
}

@end
