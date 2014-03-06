//
//  Deck.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/5/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeckViewModel : NSObject

@property (nonatomic, readonly) NSArray *blackCards;
@property (nonatomic, readonly) NSArray *redCards;
@property (nonatomic, readonly) NSArray *whiteCards;
@property (nonatomic, readonly) NSArray *blueCards;
@property (nonatomic, readonly) NSArray *greenCards;
@property (nonatomic, readonly) NSArray *artifactCards;
@property (nonatomic, readonly) NSArray *multiColorCards;
@property (nonatomic, readonly) NSArray *landCards;

@property (nonatomic) NSMutableArray *chosenCards;
@property (nonatomic) NSMutableArray *potentialCards;

- (NSInteger)cardSeperationCount;

@end
