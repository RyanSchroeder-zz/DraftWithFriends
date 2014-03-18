//
//  UserService.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGUser+Mapper.h"
#import "ServiceBase.h"

@interface UserService : ServiceBase

- (MTGUser *)currentUser;

- (void)logInUser:(MTGUser *)wcUser completed:(ServiceCompletionBlock)completed;
- (void)signUpUser:(MTGUser *)wcUser completed:(ServiceCompletionBlock)completed;

+ (UserService *)sharedService;

@end
