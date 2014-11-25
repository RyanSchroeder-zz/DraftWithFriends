//
//  UserRepository.m
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/21/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "UserRepository.h"
#import "Consts.h"

@implementation UserRepository

- (void)logOut;
{
    // Not implemented
}

- (void)logInUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed
{
    if (completed) completed(nil, nil);
}

- (void)signUpUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed
{
    if (completed) completed(nil, nil);
}

+ (UserRepository *)sharedRepository
{
	static dispatch_once_t pred = 0;
	__strong static id _sharedRepository = nil;
	
	dispatch_once(&pred, ^{
		_sharedRepository = [[self alloc] init];
	});
	
	return _sharedRepository;
}

@end
