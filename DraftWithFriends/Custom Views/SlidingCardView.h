//
//  SlidingImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_OFFSET 27

@class Card;

@protocol SlidingCardViewDelegate <NSObject>

- (void)cardRemoved:(Card *)card;

@end


@interface SlidingCardView : UIImageView

@property (nonatomic) NSInteger index;
@property (nonatomic) CGFloat originalY;
@property (nonatomic) id<SlidingCardViewDelegate> delegate;

- (id)initWithCard:(Card *)card;
- (void)slideToShowIndex:(NSInteger)index animated:(BOOL)animated;

@end
