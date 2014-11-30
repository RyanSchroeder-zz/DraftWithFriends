//
//  DraftSelectionRepository.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 11/30/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Parse/Parse.h>
#import "DraftSelectionRepository.h"

@implementation DraftSelectionRepository

- (void)draftSelectionList:(RepositoryCompletionBlock)completed
{
    PFQuery *query = [PFQuery queryWithClassName:@"draftSelectionList"];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"objects:%@", objects);
        if (!error) {
            if (completed) completed(nil, nil);
        } else {
            if (completed) completed(error, nil);
        }
    }];
}

+ (DraftSelectionRepository *)sharedRepository
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedRepository = nil;
    
    dispatch_once(&pred, ^{
        _sharedRepository = [[self alloc] init];
    });
    
    return _sharedRepository;
}

@end
