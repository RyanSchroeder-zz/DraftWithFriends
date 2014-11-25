//
//  ImageStack.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 1/16/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardStack : NSObject

@property (nonatomic) NSMutableArray *cards;
@property (nonatomic) NSInteger highlightedCardIndex;

- (id)initWithCards:(NSArray *)cards;

@end
