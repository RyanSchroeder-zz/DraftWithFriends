//
//  CardRepository.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RepositorySuccessBlock)(id object);
typedef void(^RepositoryFailureBlock)(id failObject);

@interface CardRepository : NSObject

@property (nonatomic) NSArray *cards;

+ (CardRepository *)initializeRepositoryForSet:(NSString *)setCode;

- (void)cardsWithSuccess:(RepositorySuccessBlock)success
                 failure:(RepositoryFailureBlock)failure;

@end
