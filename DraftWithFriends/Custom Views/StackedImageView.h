//
//  StackedImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageStack;
@class Card;

@protocol StackedImageViewDelegate <NSObject>

- (void)didRemoveCard:(Card *)card fromStack:(ImageStack *)imageStack;

@optional
- (void)stackedViewDidEmpty;

@end

@interface StackedImageView : UIScrollView

@property (nonatomic) id<StackedImageViewDelegate> stackedImageViewDelegate;
@property (nonatomic) NSInteger visibleImageIndex;

- (void)setCardStack:(ImageStack *)cardStack;

@end
