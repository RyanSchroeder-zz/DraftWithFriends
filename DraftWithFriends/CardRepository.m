//
//  CardRepository.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <SDWebImage/SDWebImagePrefetcher.h>
#import "CardRepository.h"
#import "Card.h"

@implementation CardRepository

+ (CardRepository *)initializeRepositoryForSet:(NSString *)setCode
{
    id instance;
    instance = [[self  alloc] init];
    
    NSString *setPath = [[[NSBundle mainBundle] URLForResource:setCode withExtension:@"json"] path];
    NSAssert(setPath, @"Couldn't find the set in the main bundle");
    
    NSError *jsonError;
            
    id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:setPath]
                                                options:0
                                                error:&jsonError];
        
    if (!jsonError) {
        NSMutableArray *mutableCardsInSet = [[NSMutableArray alloc] init];
        NSMutableArray *mutableCardImagesInSet = [[NSMutableArray alloc] init];
        
        for (id cardJSON in [json valueForKey:@"cards"]) {
            Card *currentCard = [Card cardWithDictionary:cardJSON];
            
            [mutableCardsInSet addObject:currentCard];
            [mutableCardImagesInSet addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", [setCode lowercaseString], currentCard.number]]];
        }
        [self preloadCardImages:mutableCardImagesInSet];
        [instance setCards:[self sortCardsInSetByNumber:mutableCardsInSet]];
    }
    return instance;
}

+ (NSArray *)sortCardsInSetByNumber:(NSArray *)cardsInSet
{
    return [cardsInSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *numberForCard_A = ((Card *)a).number;
        NSString *numberForCard_B = ((Card *)b).number;
        
        return [numberForCard_A compare:numberForCard_B options:NSNumericSearch];
    }];
}

+ (void)preloadCardImages:(NSArray *)cardsInSet
{
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:cardsInSet completed:^(NSUInteger finishedCount, NSUInteger skippedCount) {
        
    }];
}

- (void)cardsWithSuccess:(RepositorySuccessBlock)success failure:(RepositoryFailureBlock)failure
{
    if (success) {
        success(self.cards);
    }
}

@end
