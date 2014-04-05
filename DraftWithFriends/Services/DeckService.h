//
//  DeckService.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "ServiceBase.h"
#import "CompleteDeck.h"

@interface DeckService : ServiceBase

- (void)decksWithUserId:(NSString *)userId completed:(ServiceCompletionBlock)completed;
- (void)decksSharedWithUserId:(NSString *)userId completed:(ServiceCompletionBlock)completed;
- (void)saveDeck:(CompleteDeck *)deck;
- (void)deleteDeck:(CompleteDeck *)deck;
- (void)shareDeck:(CompleteDeck *)deck withUserEmail:(NSString *)email completed:(ServiceCompletionBlock)completed;
- (void)deck:(CompleteDeck *)deck fetchCards:(ServiceCompletionBlock)completed;

+ (DeckService *)sharedService;

@end
