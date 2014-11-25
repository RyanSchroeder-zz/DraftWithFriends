//
//  DeckViewController.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteDeck.h"

@protocol DeckViewControllerDelegate <NSObject>

- (void)returnToDraftView;

@end

@interface DeckViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<DeckViewControllerDelegate> delegate;

/** The current set of picks from the DraftViewController */
@property (nonatomic) NSArray *picks;

/** A finished deck from the DeckListViewController */
@property (nonatomic) CompleteDeck *completeDeck;

@end
