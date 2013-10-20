//
//  Player.h
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "BoosterPack.h"

typedef NS_ENUM(NSUInteger, PlayerType) {
    kHumanPlayer,
    kBotPlayer
};

@interface Player : NSObject

@property (nonatomic, readonly) int ID;
@property (nonatomic, readonly) PlayerType playerType;
@property (nonatomic, readonly) int seatPosition;
@property (nonatomic, readonly) Deck *deck;

@property (nonatomic) BoosterPack *boosterPack;

+ (Player *)playerWithID:(int)ID
              playerType:(PlayerType)playerType
            seatPosition:(int)seatPosition;

@end
