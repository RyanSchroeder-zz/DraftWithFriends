//
//  MTGUser.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "MTGUser.h"

@implementation MTGUser

- (NSString *)name
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
