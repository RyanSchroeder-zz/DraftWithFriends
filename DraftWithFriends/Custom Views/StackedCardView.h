//
//  StackedCardView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackedCardView : UIScrollView

@property (nonatomic) NSInteger visibleCardIndex;

- (void)setCardStack:(NSArray *)cardStack;

@end
