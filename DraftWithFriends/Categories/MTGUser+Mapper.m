//
//  MTGUser+Mapper.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "MTGUser+Mapper.h"

@implementation MTGUser (Mapper)

+ (NSArray *)mapPFUserArray:(NSArray *)pfUsers
{
    NSMutableArray *users = [NSMutableArray new];
    
    for (PFUser *pfUser in pfUsers) {
        if (pfUser) {
            [users addObject:[self mapPFUser:pfUser]];
        }
    }
    
    return [users copy];
}

+ (MTGUser *)mapPFUser:(PFUser *)pfUser
{
    if (!pfUser) return nil;
        
    MTGUser *user = [MTGUser new];
    
    user.userId = pfUser.objectId;
    user.firstName = pfUser[@"firstName"];
    user.lastName = pfUser[@"lastName"];
    user.email = pfUser.email;
    user.createdAt = pfUser.createdAt;
    user.pfUser = pfUser;
    
    return user;
}

@end
