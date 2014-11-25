//
//  StackedImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "StackedCardView.h"
#import "SlidingCardView.h"
#import "CardStack.h"
#import "Card.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define IMAGE_OFFSET 27
#define IMAGE_HEIGHT 285
#define IMAGE_WIDTH 200

@interface StackedCardView () <UIScrollViewDelegate, SlidingCardViewDelegate>

@property (nonatomic) CardStack *cardStack;
@property (nonatomic) NSMutableArray *cardViews;
@property (nonatomic) CGFloat normalizedContentOffset;
@property (nonatomic, getter = isConfiguringImages) BOOL configuringImages;
@property (nonatomic) UIImage *cardBack;

@end

@implementation StackedCardView

- (void)setCardStack:(CardStack *)cardStack
{
    _cardStack = cardStack;
    
    [self reloadStack];
}

- (void)reloadStack
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configureImages];
    [self configureWithHighlightedImageDisplayed];
}

- (void)slideImagesIfNeededAnimated:(BOOL)animated
{
    for (int i = 0; i < self.cardViews.count; i++) {
        [self slideImageIfNeededAtIndex:i animated:animated];
    }
}

- (void)slideImageIfNeededAtIndex:(NSInteger)index animated:(BOOL)animated
{
    return;
    SlidingCardView *image = self.cardViews[index];
    
    BOOL slideAnimationDidOccur = NO;
    
    NSInteger offset = [self currentIndex];
    
    if (offset > index && index != self.cardViews.count - 1) {
        slideAnimationDidOccur = [image slideDownAnimated:animated];
    } else if (offset < index) {
        slideAnimationDidOccur = [image slideUpAnimated:animated];
    }
    
    if (offset <= 0) {
        offset = 0;
    } else if (offset >= self.cardViews.count) {
        offset = self.cardViews.count - 1;
    }
    
    if (slideAnimationDidOccur) {
        self.highlightCardIndex = offset;
    }
}

- (NSInteger)currentIndex
{
    return floor((self.normalizedContentOffset - self.contentOffset.y) / IMAGE_OFFSET);
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isConfiguringImages) {
        [self slideImagesIfNeededAnimated:NO];
        self.configuringImages = NO;
        return;
    }
    
    [self slideImagesIfNeededAnimated:YES];
}

#pragma mark - SlidingImageViewDelegate methods

- (void)cardRemoved:(Card *)card
{
    [self.cardStack.cards removeObjectIdenticalTo:card];
    [self.stackedCardViewDelegate didRemoveCard:card fromStack:self.cardStack];
    
    if (self.cardStack.cards.count == 0 && [self.stackedCardViewDelegate respondsToSelector:@selector(stackedViewDidEmpty)]) {
        [self.stackedCardViewDelegate stackedViewDidEmpty];
    } else {
        [self reloadStack];
    }
}

#pragma mark - configure methods

- (void)configureWithHighlightedImageDisplayed
{
    [self setContentOffset:CGPointMake(0, self.normalizedContentOffset - 1 * IMAGE_OFFSET) animated:NO];
    [self slideImagesIfNeededAnimated:NO];
}

- (void)configureImages
{
    self.configuringImages = YES;
    
    for (NSInteger i = self.cardStack.cards.count - 1; i >= 0; i--) {
        Card *card = self.cardStack.cards[i];
        [self configureCardInStack:card atIndex:i];
    }
    
    [self configureContentSizeToHeightOfStackedImages];
    [self configureNormalizedOffset];
}

- (void)configureCardInStack:(Card *)card atIndex:(NSInteger)index
{
    self.cardViews = [NSMutableArray new];
    
    SlidingCardView *slidingImageView = [[SlidingCardView alloc] initWithCard:card];
    
    [slidingImageView setImageWithURL:card.smallImageURL placeholderImage:self.cardBack];
    slidingImageView.delegate = self;
    slidingImageView.originalY = (self.cardStack.cards.count - index) * IMAGE_OFFSET;
    slidingImageView.frame = [self cardFrameAtY:slidingImageView.originalY];
    
    // Visual representation is reverse order of array storage
    [self.cardViews insertObject:slidingImageView atIndex:0];
    [self addSubview:slidingImageView];
}

- (CGRect)cardFrameAtY:(CGFloat)yCoordinate
{
    return CGRectMake(0, yCoordinate, self.frame.size.width, self.frame.size.width * IMAGE_HEIGHT / IMAGE_WIDTH);
}

- (void)configureContentSizeToHeightOfStackedImages
{
    self.contentSize = CGSizeMake(self.frame.size.width,
                                  [self.cardViews[0] size].height * 2 + ((self.cardStack.cards.count + 1) * IMAGE_OFFSET));
}

- (void)configureNormalizedOffset
{
    self.normalizedContentOffset = self.contentSize.height - self.frame.size.height;
}

#pragma mark - custom inits

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.delegate = self;
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    self.cardBack = [UIImage imageNamed:@"cardback.jpg"];
    
    return self;
}

@end
