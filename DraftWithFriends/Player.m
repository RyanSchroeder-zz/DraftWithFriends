//
//  Player.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 10/20/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "Player.h"

@interface Player ()
    @property (nonatomic, readwrite) int ID;
    @property (nonatomic, readwrite) PlayerType playerType;
    @property (nonatomic, readwrite) int seatPosition;
    @property (nonatomic, readwrite) Deck *deck;
@end

@implementation Player

+ (Player *)playerWithID:(int)ID
              playerType:(PlayerType)playerType
            seatPosition:(int)seatPosition
{
    Player *instance = [[Player alloc] init];
    [instance setID:ID];
    [instance setPlayerType:playerType];
    [instance setSeatPosition:seatPosition];
    [instance setDeck:[Deck initializeDeck]];
    
    return instance;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[ID: %d, Type: %u, Seat: %d]", self.ID, self.playerType, self.seatPosition];
}

@end
