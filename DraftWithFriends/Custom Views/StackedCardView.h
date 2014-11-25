//
//  StackedImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardStack;
@class Card;

@protocol StackedCardViewDelegate <NSObject>

- (void)didRemoveCard:(Card *)card fromStack:(CardStack *)cardStack;

@optional
- (void)stackedViewDidEmpty;

@end

@interface StackedCardView : UIScrollView

@property (nonatomic) id<StackedCardViewDelegate> stackedCardViewDelegate;
@property (nonatomic) NSInteger highlightedCardIndex;

- (void)setCardStack:(CardStack *)cardStack;
- (NSInteger)currentIndex;

@end
