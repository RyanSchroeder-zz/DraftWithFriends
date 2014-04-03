//
//  DeckRepository.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Parse/Parse.h>
#import "DeckRepository.h"
#import "CompleteDeck+Mapper.h"

@implementation DeckRepository

- (void)decksWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed
{
    if (!userId) {
        if (completed) {
            completed(nil, @[]);
            return;
        }
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"CompleteDeck"];
    [query whereKey:@"userId" equalTo:userId];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (completed) completed(nil, [CompleteDeck mapPFCompleteDeckArray:objects]);
        } else {
            if (completed) completed(error, nil);
        }
    }];
}

- (void)decksSharedWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed
{
    PFQuery *query = [PFQuery queryWithClassName:@"ShareDeck"];
    [query whereKey:@"sharedWithId" equalTo:userId];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query includeKey:@"deck"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *shareDecks, NSError *error) {
        if (!error) {
            NSMutableArray *pfDecks = [NSMutableArray new];
            for (id shareDeck in shareDecks) {
                [pfDecks addObject:shareDeck[@"deck"]];
            }
            if (completed) completed(nil, [CompleteDeck mapPFCompleteDeckArray:[pfDecks copy]]);
        } else {
            if (completed) completed(error, nil);
        }
    }];
}

- (void)saveDeck:(CompleteDeck *)deck
{
    PFObject *pfDeck = [CompleteDeck mapCompleteDeck:deck];
    
    [pfDeck saveInBackground];
}

- (void)deleteDeck:(CompleteDeck *)deck
{
    PFQuery *query = [PFQuery queryWithClassName:@"CompleteDeck"];
    [query whereKey:@"objectId" equalTo:deck.pfCompletedDeck.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [object deleteInBackground];
        }
    }];
}

- (void)shareDeck:(CompleteDeck *)deck withUserEmail:(NSString *)email
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFObject *pfSharedDeck = [self shareDeck:deck withUserId:object.objectId];
            [pfSharedDeck saveInBackground];
        } else {
            NSLog(@"error sharing:%@", error);
        }
    }];
}

- (PFObject *)shareDeck:(CompleteDeck *)deck withUserId:(NSString *)sharedWithId
{
    PFObject *shareDeck = [PFObject objectWithClassName:@"ShareDeck"];
    
    shareDeck[@"deck"] = deck.pfCompletedDeck;
    shareDeck[@"sharedWithId"] = sharedWithId;
    
    return shareDeck;
}

+ (DeckRepository *)sharedRepository
{
	static dispatch_once_t pred = 0;
	__strong static id _sharedRepository = nil;
	
	dispatch_once(&pred, ^{
		_sharedRepository = [[self alloc] init];
	});
	
	return _sharedRepository;
}

@end
