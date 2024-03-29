//
//  ListedDeckCell.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListedDeckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageCMCLabel;
@property (weak, nonatomic) IBOutlet UILabel *draftedByLabel;

@end
