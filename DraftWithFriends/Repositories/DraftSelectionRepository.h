//
//  DraftSelectionRepository.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 11/30/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "RepositoryBase.h"

@interface DraftSelectionRepository : RepositoryBase

- (void)draftSelectionList:(RepositoryCompletionBlock)completed;
+ (DraftSelectionRepository *)sharedRepository;

@end
