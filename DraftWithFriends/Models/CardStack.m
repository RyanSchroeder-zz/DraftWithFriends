//
//  ImageStack.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 1/16/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "CardStack.h"
#import "Card.h"

@implementation CardStack

- (id)initWithCards:(NSArray *)cards
{
    self = [super init];
    
    if (self) {
        self.cards = [cards mutableCopy];
        self.highlightedCardIndex = 0;
    }
    
    return self;
}

@end
