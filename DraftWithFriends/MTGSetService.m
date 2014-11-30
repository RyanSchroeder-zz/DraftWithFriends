//
//  MTGSetService.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 10/20/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "DraftSelectionRepository.h"
#import "MTGSetService.h"
#import "Card.h"

@interface MTGSetService ()

@property (nonatomic) NSInteger boosterPackSize;

@end

@implementation MTGSetService

- (void)draftSelectionList:(ServiceCallback)completed
{
    [[DraftSelectionRepository sharedRepository] draftSelectionList:completed];
}

- (void)setWithSetCode:(NSString *)setCode callback:(ServiceCallback)callback
{
    NSError *error;
    
    NSString *setPath = [[[NSBundle mainBundle] URLForResource:setCode withExtension:@"json"] path];
    
    if (!setPath) {
        callback([NSError errorWithDomain:@"Couldn't find set in bundle" code:404 userInfo:nil], nil);
        return;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:setPath]
                                              options:0
                                                error:&error];
    
    if (!error) {
        NSMutableArray *mutableCardsInSet = [[NSMutableArray alloc] init];
        NSMutableArray *mutableCardImagesInSet = [[NSMutableArray alloc] init];
        
        for (id cardJSON in [json valueForKey:@"cards"]) {
            Card *currentCard = [Card cardWithDictionary:cardJSON];
            currentCard.setCode = [setCode lowercaseString];
            
            [mutableCardsInSet addObject:currentCard];
            [mutableCardImagesInSet addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", [setCode lowercaseString], currentCard.numberInSet]]];
        }
        
        MTGSet *setToReturn = [MTGSet setWithCards:[self sortCardsInSetByNumber:mutableCardsInSet] setCode:setCode];
        
        self.boosterPackSize = [setToReturn generateBoosterPack].count;
        
        callback(nil, setToReturn);
    } else {
        callback(error, nil);
    }
}


- (MTGSet *)setWithSetCode:(NSString *)setCode
{
    NSError *error;
    
    setCode = [setCode uppercaseString];
    
    NSString *setPath = [[[NSBundle mainBundle] URLForResource:setCode withExtension:@"json"] path];
    
    if (!setPath) {
        return nil;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:setPath]
                                              options:0
                                                error:&error];
    
    if (!error) {
        NSMutableArray *mutableCardsInSet = [[NSMutableArray alloc] init];
        NSMutableArray *mutableCardImagesInSet = [[NSMutableArray alloc] init];
        
        for (id cardJSON in [json valueForKey:@"cards"]) {
            Card *currentCard = [Card cardWithDictionary:cardJSON];
            currentCard.setCode = [setCode lowercaseString];
            
            [mutableCardsInSet addObject:currentCard];
            [mutableCardImagesInSet addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", [setCode lowercaseString], currentCard.numberInSet]]];
        }
        
        MTGSet *setToReturn = [MTGSet setWithCards:[self sortCardsInSetByNumber:mutableCardsInSet] setCode:setCode];
        
        self.boosterPackSize = [setToReturn generateBoosterPack].count;
        
        return setToReturn;
    }
    
    return nil;
}

- (NSInteger)boosterPackSize
{
    return _boosterPackSize;
}

- (NSArray *)sortCardsInSetByNumber:(NSArray *)cardsInSet
{
    return [cardsInSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *numberForCard_A = ((Card *)a).numberInSet;
        NSString *numberForCard_B = ((Card *)b).numberInSet;
        
        return [numberForCard_A compare:numberForCard_B options:NSNumericSearch];
    }];
}

- (NSArray *)basicTherosLands
{
    NSString *setCode = @"THS";
    
    NSString *setPath = [[[NSBundle mainBundle] URLForResource:setCode withExtension:@"json"] path];
    
    id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:setPath]
                                              options:0
                                                error:nil];
    
    NSMutableArray *mutableCardsInSet = [[NSMutableArray alloc] init];
    NSMutableArray *mutableCardImagesInSet = [[NSMutableArray alloc] init];
    
    for (id cardJSON in [json valueForKey:@"cards"]) {
        Card *currentCard = [Card cardWithDictionary:cardJSON];
        currentCard.setCode = [setCode lowercaseString];
        
        [mutableCardsInSet addObject:currentCard];
        [mutableCardImagesInSet addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", [setCode lowercaseString], currentCard.numberInSet]]];
    }
    
    MTGSet *setToReturn = [MTGSet setWithCards:[self sortCardsInSetByNumber:mutableCardsInSet] setCode:setCode];
    
    return [setToReturn basicLands];
}

- (Card *)cardWithSetCode:(NSString *)setCode andNumber:(NSString *)number
{
    return [[self setWithSetCode:setCode] cardWithNumber:number];
}

- (NSArray *)landType:(LandType)landType withCount:(NSInteger)count
{
    if (count == 0) {
        return @[];
    }
    
    NSMutableArray *landsToDeliver = [NSMutableArray new];
    
    switch (landType) {
        case LandSwamp:
            for (NSInteger i = 0; i < count; i++) {
                [landsToDeliver addObject:[self swamp]];
            }
            break;
        case LandMountain:
            for (NSInteger i = 0; i < count; i++) {
                [landsToDeliver addObject:[self mountain]];
            }
            break;
        case LandPlains:
            for (NSInteger i = 0; i < count; i++) {
                [landsToDeliver addObject:[self plains]];
            }
            break;
        case LandIsland:
            for (NSInteger i = 0; i < count; i++) {
                [landsToDeliver addObject:[self island]];
            }
            break;
        case LandForest:
            for (NSInteger i = 0; i < count; i++) {
                [landsToDeliver addObject:[self forest]];
            }
            break;
            
        default:
            break;
    }
    
    return landsToDeliver;
}

- (Card *)swamp;
{
    NSArray *basicLands = [self basicTherosLands];
    
    for (Card *land in basicLands) {
        if ([land.rulesText isEqualToString:@"B"]) {
            return land;
        }
    }
    
    return nil;
}

- (Card *)mountain;
{
    NSArray *basicLands = [self basicTherosLands];
    
    for (Card *land in basicLands) {
        if ([land.rulesText isEqualToString:@"R"]) {
            return land;
        }
    }
    
    return nil;
}

- (Card *)plains;
{
    NSArray *basicLands = [self basicTherosLands];
    
    for (Card *land in basicLands) {
        if ([land.rulesText isEqualToString:@"W"]) {
            return land;
        }
    }
    
    return nil;
}

- (Card *)island;
{
    NSArray *basicLands = [self basicTherosLands];
    
    for (Card *land in basicLands) {
        if ([land.rulesText isEqualToString:@"U"]) {
            return land;
        }
    }
    
    return nil;
}

- (Card *)forest;
{
    NSArray *basicLands = [self basicTherosLands];
    
    for (Card *land in basicLands) {
        if ([land.rulesText isEqualToString:@"G"]) {
            return land;
        }
    }
    
    return nil;
}

+ (MTGSetService *)sharedService
{
    static dispatch_once_t pred = 0;
    __strong static MTGSetService *_sharedService = nil;
    
    dispatch_once(&pred, ^{
        _sharedService = [[self alloc] init];
    });
    
    return _sharedService;
}

@end
