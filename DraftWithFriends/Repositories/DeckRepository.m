//
//  DeckRepository.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DeckRepository.h"

@implementation DeckRepository

- (void)decksWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed
{
    if (completed) completed(nil, nil);
}

- (void)decksSharedWithUserId:(NSString *)userId completed:(RepositoryCompletionBlock)completed
{
    if (completed) completed(nil, nil);
}

- (void)saveDeck:(CompleteDeck *)deck
{
    // Not implemented
}

- (void)deleteDeck:(CompleteDeck *)deck
{
    // Not implemented
}

- (void)shareDeck:(CompleteDeck *)deck withUserEmail:(NSString *)email completed:(RepositoryCompletionBlock)completed
{
    if (completed) completed(nil, nil);
}

- (id)shareDeck:(CompleteDeck *)deck withUserId:(NSString *)sharedWithId
{
    return nil;
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
