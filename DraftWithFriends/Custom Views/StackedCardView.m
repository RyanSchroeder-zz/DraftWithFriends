//
//  StackedCardView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "StackedCardView.h"
#import "SlidingImageView.h"

#define CARD_OFFSET 27

@interface StackedCardView () <UIScrollViewDelegate>

@property (nonatomic) NSArray *cardImageViews;
@property (nonatomic) CGFloat startingContentOffset;

@end

@implementation StackedCardView

- (void)setCardStack:(NSArray *)cardStack
{
    [self configureViewWithCards:cardStack];
    [self displayCards];
}

- (void)displayCards
{
    for (int i = 0; i < self.cardImageViews.count; i++) {
        SlidingImageView *imageView = self.cardImageViews[i];
        imageView.frame = [self cardFrame];
        imageView.originalY = imageView.frame.size.height + i * CARD_OFFSET;
        imageView.frame = CGRectOffset(imageView.frame, 0, imageView.originalY);
        
        [self addSubview:imageView];
    }
    
    NSInteger startingIndex = self.cardImageViews.count - self.visibleCardIndex;
    self.contentOffset = CGPointMake(0, self.startingContentOffset - startingIndex * CARD_OFFSET);
}

- (CGRect)cardFrame
{
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * 285 / 200);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    SlidingImageView *card = self.cardImageViews[self.visibleCardIndex];
    
    NSInteger index = self.cardImageViews.count - self.visibleCardIndex;
    CGFloat offset = self.startingContentOffset - self.contentOffset.y;
    
    if (offset > index * CARD_OFFSET) {
        self.visibleCardIndex--;
        [UIView animateWithDuration:0.2 animations:^{
            [card slideDown];
        }];
    } else {
        self.visibleCardIndex++;
        [UIView animateWithDuration:0.2 animations:^{
            [card slideUp];
        }];
    }
    
    if (self.visibleCardIndex <= 0) {
        self.visibleCardIndex = 1;
    } else if (self.visibleCardIndex >= self.cardImageViews.count) {
        self.visibleCardIndex = self.cardImageViews.count - 1;
    }
}

#pragma mark - configure methods

- (void)configureViewWithCards:(NSArray *)cards
{
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    for (UIImage *image in cards) {
        SlidingImageView *imageView = [[SlidingImageView alloc] initWithImage:image];
        [imageViews addObject:imageView];
    }
    
    self.cardImageViews = [imageViews copy];
    
    self.contentSize = CGSizeMake(self.frame.size.width, [self.cardImageViews[0] size].height * 2 + (self.cardImageViews.count * CARD_OFFSET));
    
    self.startingContentOffset = self.contentSize.height - self.frame.size.height;
    self.contentOffset = CGPointMake(0, self.startingContentOffset);
    
    self.visibleCardIndex = self.cardImageViews.count - 1;
}

#pragma mark - custom inits

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.delegate = self;
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    
    return self;
}

@end
