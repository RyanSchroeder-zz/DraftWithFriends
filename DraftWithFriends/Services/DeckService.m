//
//  DeckService.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "DeckService.h"
#import "UserService.h"
#import "DeckRepository.h"

@implementation DeckService

- (void)saveDeck:(CompleteDeck *)deck
{
    [[DeckRepository sharedRepository] saveDeck:deck];
}

- (void)deleteDeck:(CompleteDeck *)deck
{
    [[DeckRepository sharedRepository] deleteDeck:deck];
}

- (void)decksWithUserId:(NSString *)userId completed:(ServiceCompletionBlock)completed
{
    [[DeckRepository sharedRepository] decksWithUserId:userId completed:completed];
}

- (void)decksSharedWithUserId:(NSString *)userId completed:(ServiceCompletionBlock)completed
{
    [[DeckRepository sharedRepository] decksSharedWithUserId:userId completed:completed];
}

- (void)shareDeck:(CompleteDeck *)deck withUserEmail:(NSString *)email completed:(ServiceCompletionBlock)completed
{
    [[DeckRepository sharedRepository] shareDeck:deck withUserEmail:email completed:completed];
}

- (void)deck:(CompleteDeck *)deck fetchCards:(ServiceCompletionBlock)completed;
{
    if (completed) completed(nil, nil);
}

+ (DeckService *)sharedService
{
	static dispatch_once_t pred = 0;
	__strong static id _shared = nil;
	
	dispatch_once(&pred, ^{
		_shared = [[self alloc] init];
	});
	
	return _shared;
}

@end
