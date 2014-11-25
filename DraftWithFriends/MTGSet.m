//
//  MTGSet.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
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

- (NSArray *)mythicRares
{
    NSMutableArray *mythicRares = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *mythicRarePredicate = [NSPredicate predicateWithFormat:@"SELF.rarity == 'Mythic Rare'"];
    
    return [mythicRares filteredArrayUsingPredicate:mythicRarePredicate];
}
- (NSArray *)rares
{
    NSMutableArray *rares = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *rarePredicate = [NSPredicate predicateWithFormat:@"SELF.rarity == 'Rare'"];
    
    return [rares filteredArrayUsingPredicate:rarePredicate];
}
- (NSArray *)uncommons
{
    NSMutableArray *uncommons = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *uncommonPredicate = [NSPredicate predicateWithFormat:@"SELF.rarity == 'Uncommon'"];
    
    return [uncommons filteredArrayUsingPredicate:uncommonPredicate];
}
- (NSArray *)commons
{
    NSMutableArray *commons = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *commonPredicate = [NSPredicate predicateWithFormat:@"SELF.rarity == 'Common'"];
    
    return [commons filteredArrayUsingPredicate:commonPredicate];
}

- (NSArray *)basicLands
{
    NSMutableArray *basicLands = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *basicLandPredicate = [NSPredicate predicateWithFormat:@"SELF.rarity == 'Basic Land'"];
    
    return [basicLands filteredArrayUsingPredicate:basicLandPredicate];
}

- (Card *)cardWithNumber:(NSString *)number
{
    NSMutableArray *cards = [NSMutableArray arrayWithArray:self.cardsInSet];
    NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"SELF.numberInSet == %@", number];
    
    return [[cards filteredArrayUsingPredicate:cardPredicate] firstObject];
}

//NOTE: This does not work for RTR,GTC,DGM because those sets did some funky business with lands.
- (NSArray *)generateBoosterPack
{
    NSMutableArray *boosterPack = [[NSMutableArray alloc] init];
    [boosterPack addObject:[self generateBoosterRareSlot]];
    [boosterPack addObjectsFromArray:[self generateBoosterUncommonSlots]];
    [boosterPack addObjectsFromArray:[self generateBoosterCommonAndLandSlots]];
    
    return boosterPack;
}

- (NSArray *)generateBoosterPackMinus:(NSInteger)numPicked
{
    NSMutableArray *booster = [[self generateBoosterPack] mutableCopy];
    
    while (numPicked > 0) {
        [booster removeObjectAtIndex:0];
        numPicked--;
    }
    
    return [booster copy];
}

- (Card *)generateBoosterRareSlot
{
    if ([self didGenerateMythicRare])
    {
        NSArray *mythics = [self mythicRares];
        return [mythics objectAtIndex:arc4random_uniform((int)[mythics count])];
    }
    else
    {
        NSArray *rares = [self rares];
        return [rares objectAtIndex:arc4random_uniform((int)[rares count])];
    }
}

- (NSArray *)generateBoosterUncommonSlots
{
    NSUInteger numberOfUncommonsInBooster = 3;
    NSMutableArray *chosenUncommons = [[NSMutableArray alloc] init];
    
    NSArray *uncommons = [self uncommons];
    
    while ([chosenUncommons count] < numberOfUncommonsInBooster)
    {
        Card *randomUncommon = [uncommons objectAtIndex:arc4random_uniform((int)[uncommons count])];
        if (![chosenUncommons containsObject:randomUncommon])
        {
            [chosenUncommons addObject:randomUncommon];
        }
    }
    
    return chosenUncommons;
}

- (NSArray *)generateBoosterCommonAndLandSlots
{
    NSMutableArray *chosenCommons = [[NSMutableArray alloc] init];
    NSUInteger numberOfCommonsInBooster = 10;
    Card *chosenLand = nil;
    
    if ([self didGenerateFoil])
    {
        Card *foilCard = [self generateBoosterFoilSlot];
        if ([foilCard.rarity isEqualToString:@"Basic Land"]) {
            chosenLand = foilCard;
        } else if (foilCard) {
            [chosenCommons addObject:foilCard];
        }
    }
    
    NSArray *commonsInSet = [self commons];
    
    while ([chosenCommons count] < numberOfCommonsInBooster)
    {
        Card *randomCommon = [commonsInSet objectAtIndex:arc4random_uniform((int)[commonsInSet count])];
        if (![chosenCommons containsObject:randomCommon])
        {
            [chosenCommons addObject:randomCommon];
        }
    }
    
    if (!chosenLand)
    {
        chosenLand = [self generateBoosterBasicLandSlot];
    }
    
    NSMutableArray *chosenCommonsAndLand = [[NSMutableArray alloc] initWithArray:chosenCommons];
    if (chosenLand) {
        [chosenCommonsAndLand addObject:chosenLand];
    }
    
    return chosenCommonsAndLand;
}

- (Card *)generateBoosterBasicLandSlot
{
    NSArray *basicLands = [self basicLands];
    if (basicLands.count == 0) {
        return nil;
    }
    return [basicLands objectAtIndex:arc4random_uniform((int)[basicLands count])];
}

- (Card *)generateBoosterFoilUncommonSlot
{
    NSArray *uncommons = [self uncommons];
    return [uncommons objectAtIndex:arc4random_uniform((int)[uncommons count])];
}

- (Card *)generateBoosterFoilCommonSlot
{
    NSArray *commons = [self commons];
    return [commons objectAtIndex:arc4random_uniform((int)[commons count])];
}

- (Card *)generateBoosterFoilSlot
{
    //1r, 3u, 10c, 1bl
    NSUInteger rarityOfFoil = arc4random_uniform(15) + 1;
    
    if (rarityOfFoil == 15) { //Rare
        return [self generateBoosterRareSlot];
    }
    else if (rarityOfFoil >= 12) { //Uncommon
        return [self generateBoosterFoilUncommonSlot];
    }
    else if (rarityOfFoil >= 2) { //Common
        return [self generateBoosterFoilCommonSlot];
    }
    else { //Basic Land
        return [self generateBoosterBasicLandSlot];
    }
}

- (BOOL)didGenerateMythicRare
{
    return (arc4random_uniform(8) + 1) == 8;
}

- (BOOL)didGenerateFoil
{
    return (arc4random_uniform(4) + 1) == 4;
}

@end
