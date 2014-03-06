//
//  MTGSetService.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "MTGSetService.h"
#import "Card.h"

@interface MTGSetService ()

@property (nonatomic) NSInteger boosterPackSize;

@end

@implementation MTGSetService

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

+ (MTGSetService *)sharedService
{
    static dispatch_once_t pred = 0;
    __strong static MTGSetService *_sharedService = nil;
    
    dispatch_once(&pred, ^{
        NSLog(@"self is : %@", self);
        _sharedService = [[self alloc] init];
    });
    
    return _sharedService;
}

@end
