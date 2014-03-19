//
//  DeckService.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DeckService.h"
#import "DeckRepository.h"

@implementation DeckService

- (void)saveDeck:(CompleteDeck *)deck
{
    [[DeckRepository sharedRepository] saveDeck:deck];
}

- (void)decksWithUserId:(NSString *)userId completed:(ServiceCompletionBlock)completed
{
    [[DeckRepository sharedRepository] decksWithUserId:userId completed:completed];
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
