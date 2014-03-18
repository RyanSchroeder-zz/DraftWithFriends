//
//  UserRepository.m
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/21/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "UserRepository.h"
#import "MTGUser+Mapper.h"
#import "Consts.h"
#import <Parse/Parse.h>

@implementation UserRepository

- (void)logOut;
{
    [PFUser logOut];
}

- (void)logInUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed
{
    [PFUser logInWithUsernameInBackground:mtgUser.email password:mtgUser.password
                                    block:^(PFUser *user, NSError *error)
     {
         if (user) {
             if (completed) completed(nil, [MTGUser mapPFUser:user]);
         } else {
             if (completed) completed(error, nil);
         }
     }];
}

- (void)signUpUser:(MTGUser *)mtgUser completed:(RepositoryCompletionBlock)completed
{
    PFUser *user = [PFUser user];
    user.username = mtgUser.email;
    user.password = mtgUser.password;
    user.email = mtgUser.email;
    
    user[@"firstName"] = mtgUser.firstName;
    user[@"lastName"] = mtgUser.lastName;
    
    mtgUser.pfUser = user;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completed) completed(error, nil);
    }];
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
