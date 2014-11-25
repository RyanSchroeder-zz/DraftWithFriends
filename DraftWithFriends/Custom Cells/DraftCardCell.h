//
//  DraftCardCell.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface DraftCardCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (nonatomic) Card *card;

@end
