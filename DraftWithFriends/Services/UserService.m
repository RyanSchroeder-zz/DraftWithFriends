
//
//  UserService.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "UserService.h"
#import "UserRepository.h"
#import "Consts.h"

@implementation UserService

#pragma mark - public methods

- (MTGUser *)currentUser
{
    return nil;
}

- (void)logInUser:(MTGUser *)mtgUser completed:(ServiceCompletionBlock)completed
{
    [[UserRepository sharedRepository] logInUser:mtgUser completed:^(id failureObject, MTGUser *loggedInUser) {
        if (!failureObject) {
            [self saveEmail_:loggedInUser.email];
        }
        
        if (completed) completed(failureObject, nil);
    }];
}

- (void)signUpUser:(MTGUser *)mtgUser completed:(ServiceCompletionBlock)completed
{
    [[UserRepository sharedRepository] signUpUser:mtgUser completed:^(id failureObject, id object) {
        if (!failureObject) {
            [self saveEmail_:mtgUser.email];
        }
        
        if (completed) completed(failureObject, nil);
    }];
}

- (void)logOut
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTGUserLogOutNotificationKey object:self];
}

#pragma mark - private methods

- (void)saveEmail_:(NSString *)email
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:email forKey:kEmailKey];
}

+ (UserService *)sharedService
{
	static dispatch_once_t pred = 0;
	__strong static id _shared = nil;
	
	dispatch_once(&pred, ^{
		_shared = [[self alloc] init];
	});
	
	return _shared;
}

@end
