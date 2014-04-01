//
//  CardDetailViewController.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/31/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (nonatomic) Card *card;

- (id)initWithImage:(UIImage *)image card:(Card *)card;
- (void)presentModalViewInView:(UIView *)view;
- (void)dismissModalView;

@end
