//
//  MTGSetService.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTGSet.h"
#import "Card.h"

typedef void(^ServiceCallback)(NSError *error, id successObject);

@interface MTGSetService : NSObject

+ (MTGSetService *)sharedService;

- (void)setWithSetCode:(NSString *)setCode
              callback:(ServiceCallback)callback;
- (NSInteger)boosterPackSize;

@end
