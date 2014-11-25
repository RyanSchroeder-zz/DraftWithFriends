//
//  SlidingImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@protocol SlidingImageViewDelegate <NSObject>

- (void)cardRemoved:(Card *)card;

@end


@interface SlidingImageView : UIImageView

@property (nonatomic) CGFloat originalY;
@property (nonatomic) id<SlidingImageViewDelegate> delegate;

- (id)initWithCard:(Card *)card;
- (BOOL)slideDownAnimated:(BOOL)animated;
- (BOOL)slideUpAnimated:(BOOL)animated;

@end
