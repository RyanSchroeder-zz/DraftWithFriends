//
//  UserRepository.h
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/21/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <Parse/Parse.h>
#import "RepositoryBase.h"
#import "MTGUser.h"

@interface UserRepository : RepositoryBase

- (void)logOut;
- (void)logInUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed;
- (void)signUpUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed;

+ (UserRepository *)sharedRepository;

@end
