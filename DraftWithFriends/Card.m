//
//  Card.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "Card.h"

NSString * const kCardNameKey = @"name";
NSString * const kCardNamesKey = @"names";
NSString * const kCardManaCostKey = @"manaCost";
NSString * const kCardConvertedManaCostKey = @"cmc";
NSString * const kCardColorsKey = @"colors";
NSString * const kCardSuperTypesKey = @"supertypes";
NSString * const kCardTypesKey = @"types";
NSString * const kCardSubTypesKey = @"subtypes";
NSString * const kCardRarityKey = @"rarity";
NSString * const kCardRulesTextKey = @"text";
NSString * const kCardNumberKey = @"number";

@interface Card ()
    @property (nonatomic, readwrite) int ID;
    @property (nonatomic, readwrite) NSString *name;
    @property (nonatomic, readwrite) NSArray *names;
    @property (nonatomic, readwrite) NSString *manaCost; //{U}{G}
    @property (nonatomic, readwrite) double convertedManaCost;
    @property (nonatomic, readwrite) NSArray *colors;
    @property (nonatomic, readwrite) NSArray *superTypes; //legendary//basic//snow
    @property (nonatomic, readwrite) NSArray *types; //instant//sorcery//creature
    @property (nonatomic, readwrite) NSArray *subTypes; //cat//angel//merfolk
    @property (nonatomic, readwrite) NSString *rarity;
    @property (nonatomic, readwrite) NSString *rulesText;
    @property (nonatomic, readwrite) NSString *number;
@end

@implementation Card

+ (Card *)cardWithDictionary:(NSDictionary *)cardDictionary
{
    Card *instance = [[Card alloc] init];
    
    [instance setName:[cardDictionary valueForKey:kCardNameKey]];
    [instance setNames:[cardDictionary valueForKey:kCardNamesKey]];
    [instance setManaCost:[cardDictionary valueForKey:kCardManaCostKey]];
    [instance setConvertedManaCost:[[cardDictionary valueForKey:kCardConvertedManaCostKey] doubleValue]];
    [instance setColors:[cardDictionary valueForKey:kCardColorsKey]];
    [instance setSuperTypes:[cardDictionary valueForKey:kCardSuperTypesKey]];
    [instance setTypes:[cardDictionary valueForKey:kCardTypesKey]];
    [instance setSubTypes:[cardDictionary valueForKey:kCardSubTypesKey]];
    [instance setRarity:[cardDictionary valueForKey:kCardRarityKey]];
    [instance setRulesText:[cardDictionary valueForKey:kCardRulesTextKey]];
    [instance setNumber:[cardDictionary valueForKey:kCardNumberKey]];
    
    return instance;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[[[[\r%@\r%@\r%@\r]]]]", self.manaCost, self.name, self.rulesText];
}

@end
