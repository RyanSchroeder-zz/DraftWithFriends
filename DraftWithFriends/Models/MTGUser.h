//
//  MTGUser.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFUser;

@interface MTGUser : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) PFUser *pfUser;

@end
