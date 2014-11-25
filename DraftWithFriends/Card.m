//
//  Card.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 9/11/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
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
NSString * const kCardNumberInSetKey = @"number";

@interface Card ()

@property (nonatomic, readwrite) int ID;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSArray *names;
@property (nonatomic, readwrite) NSString *manaCost; //{U}{G}
@property (nonatomic, readwrite) CGFloat convertedManaCost;
@property (nonatomic, readwrite) NSArray *colors;
@property (nonatomic, readwrite) NSArray *superTypes; //legendary//basic//snow
@property (nonatomic, readwrite) NSArray *types; //instant//sorcery//creature
@property (nonatomic, readwrite) NSArray *subTypes; //cat//angel//merfolk
@property (nonatomic, readwrite) NSString *rarity;
@property (nonatomic, readwrite) NSString *rulesText;
@property (nonatomic, readwrite) NSString *numberInSet;

@property (nonatomic, readwrite) UIImage *smallImage;

@end

@implementation Card

- (NSURL *)smallImageURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", self.setCode, self.numberInSet]];
}

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
    [instance setNumberInSet:[cardDictionary valueForKey:kCardNumberInSetKey]];
    
    return instance;
}

- (BOOL)isBlack
{
    if ([self isMultiColored]) {
        return NO;
    }
    
    for (NSString *color in self.colors) {
        if ([[color lowercaseString] isEqualToString:@"black"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isRed
{
    if ([self isMultiColored]) {
        return NO;
    }
    
    for (NSString *color in self.colors) {
        if ([[color lowercaseString] isEqualToString:@"red"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isWhite
{
    if ([self isMultiColored]) {
        return NO;
    }
    
    for (NSString *color in self.colors) {
        if ([[color lowercaseString] isEqualToString:@"white"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isBlue
{
    if ([self isMultiColored]) {
        return NO;
    }
    
    for (NSString *color in self.colors) {
        if ([[color lowercaseString] isEqualToString:@"blue"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isGreen
{
    if ([self isMultiColored]) {
        return NO;
    }
    
    for (NSString *color in self.colors) {
        if ([[color lowercaseString] isEqualToString:@"green"]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isMultiColored
{
    return self.colors.count > 1;
}

- (BOOL)isArtifact
{
    return self.colors.count == 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\r\r%@\r%@\r%@\r%@\r\r", self.rarity, self.manaCost, self.name, self.rulesText];
}

@end
