//
//  DeckRepository.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "RepositoryBase.h"
#import "CompleteDeck.h"

@interface DeckRepository : RepositoryBase

- (void)decksWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed;
- (void)decksSharedWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed;
- (void)saveDeck:(CompleteDeck *)deck;
- (void)deleteDeck:(CompleteDeck *)deck;
- (void)shareDeck:(CompleteDeck *)deck withUserEmail:(NSString *)email completed:(RepositoryCompletionBlock)completed;

+ (DeckRepository *)sharedRepository;

@end
