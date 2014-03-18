//
//  MTGUser+Mapper.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "MTGUser.h"
#import <Parse/Parse.h>

@interface MTGUser (Mapper)

+ (NSArray *)mapPFUserArray:(NSArray *)pfUsers;
+ (MTGUser *)mapPFUser:(PFUser *)pfUser;

@end
