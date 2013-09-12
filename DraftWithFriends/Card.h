//
//  Card.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

extern NSString * const kCardNameKey;
extern NSString * const kCardNamesKey;
extern NSString * const kCardManaCostKey;
extern NSString * const kCardConvertedManaCostKey;
extern NSString * const kCardColorsKey;
extern NSString * const kCardSuperTypesKey;
extern NSString * const kCardTypesKey;
extern NSString * const kCardSubTypesKey;
extern NSString * const kCardRarityKey;
extern NSString * const kCardRulesTextKey;
extern NSString * const kCardNumberKey;

+ (Card *)cardWithDictionary:(NSDictionary *)cardDictionary;

@property (nonatomic, readonly) int ID;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray *names;
@property (nonatomic, readonly) NSString *manaCost; //{U}{G}
@property (nonatomic, readonly) double convertedManaCost;
@property (nonatomic, readonly) NSArray *colors;
@property (nonatomic, readonly) NSArray *superTypes; //legendary//basic//snow
@property (nonatomic, readonly) NSArray *types; //instant//sorcery//creature
@property (nonatomic, readonly) NSArray *subTypes; //cat//angel//merfolk
@property (nonatomic, readonly) NSString *rarity;
@property (nonatomic, readonly) NSString *rulesText;
@property (nonatomic, readonly) NSString *number;

@end
