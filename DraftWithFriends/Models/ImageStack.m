//
//  ImageStack.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 1/16/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "ImageStack.h"
#import "Card.h"

@implementation ImageStack

- (id)initWithCards:(NSArray *)cards
{
    self = [super init];
    
    if (self) {
        self.cards = cards;
        self.visibleImageIndex = 0;
    }
    
    return self;
}

@end
