//
//  CompleteDeck+Mapper.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "CompleteDeck+Mapper.h"
#import "MTGSetService.h"
#import "UserService.h"

@implementation CompleteDeck (Mapper)

+ (NSArray *)mapPFCompleteDeckArray:(NSArray *)pfDecks
{
    NSMutableArray *decks = [NSMutableArray new];
    
    for (PFObject *pfDeck in pfDecks) {
        CompleteDeck *deck = [self mapPFCompleteDeck:pfDeck];
        deck.pfCompletedDeck = pfDeck;
        [decks addObject:deck];
    }
    
    return [decks copy];
}

+ (CompleteDeck *)mapPFCompleteDeck:(PFObject *)pfDeck
{
    if (!pfDeck) return nil;
    
    CompleteDeck *deck = [[CompleteDeck alloc] initWithCards:[self cardsForKeys_:pfDeck[@"cards"]]
                                                featuredCard:[self cardForKey_:pfDeck[@"featuredCard"]]
                                                      userId:pfDeck[@"userId"]
                                                 dateDrafted:pfDeck.createdAt];;
    
    return deck;
}


+ (PFObject *)mapCompleteDeck:(CompleteDeck *)deck
{
    PFObject *deckObject = [PFObject objectWithClassName:@"CompleteDeck"];
    
    deckObject[@"userId"] = [[UserService sharedService] currentUser].userId;
    deckObject[@"featuredCard"] = [self keyForCard_:deck.featuredCard];
    deckObject[@"cards"] = [self keysForCards_:deck.cards];
    deckObject[@"colors"] = deck.colors;
    deckObject[@"averageCMC"] = deck.averageCMC;
    
    return deckObject;
}

#pragma mark - Private methods


+ (NSArray *)cardsForKeys_:(NSArray *)keys
{
    NSMutableArray *cards = [NSMutableArray new];
    
    for (NSString *key in keys) {
        [cards addObject:[self cardForKey_:key]];
    }
    
    return [cards copy];
}

+ (NSArray *)keysForCards_:(NSArray *)cards
{
    NSMutableArray *keys = [NSMutableArray new];
    
    for (Card *card in cards) {
        [keys addObject:[self keyForCard_:card]];
    }
    
    return [keys copy];
}

+ (NSString *)keyForCard_:(Card *)card
{
    return [NSString stringWithFormat:@"%@,%@", card.setCode, card.numberInSet];
}

+ (Card *)cardForKey_:(NSString *)key
{
    NSString *setCode = [key substringToIndex:3];
    NSString *numberInSet = [key substringFromIndex:4];
    
    return [[MTGSetService sharedService] cardWithSetCode:setCode andNumber:numberInSet];
}

@end
