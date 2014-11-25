//
//  DraftViewController.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTGSet;

@protocol DraftViewControllerDelegate <NSObject>

- (void)newDraftDesired;

@end

@interface DraftViewController : UIViewController

@property (weak, nonatomic) id<DraftViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSArray *cards;
@property (nonatomic) MTGSet *cardSet;

@end
