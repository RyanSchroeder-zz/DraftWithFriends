//
//  UserService.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceBase.h"
#import "MTGUser.h"

@interface UserService : ServiceBase

- (MTGUser *)currentUser;

- (void)logInUser:(MTGUser *)wcUser completed:(ServiceCompletionBlock)completed;
- (void)signUpUser:(MTGUser *)wcUser completed:(ServiceCompletionBlock)completed;
- (void)logOut;

+ (UserService *)sharedService;

@end
