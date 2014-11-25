//
//  DrawViewModel.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface DrawViewModel : NSObject

@property (nonatomic) NSMutableArray *cardsDrawn;
@property (nonatomic) NSMutableArray *cardsPlayed;
@property (nonatomic) NSMutableArray *cardsInLibrary;

- (void)drawHand;
- (void)drawCard;

@end
