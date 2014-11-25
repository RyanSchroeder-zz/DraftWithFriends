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

#define IMAGE_HEIGHT 285
#define IMAGE_WIDTH 200

@interface StackedCardView () <UIScrollViewDelegate, SlidingCardViewDelegate>

@property (nonatomic) CardStack *cardStack;
@property (nonatomic) NSMutableArray *cardViews;
@property (nonatomic) CGFloat normalizedContentOffset;
@property (nonatomic) UIImage *cardBack;
@property (nonatomic, getter=isConfiguringCardDisplay) BOOL configuringCardDisplay;

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
    
    [self configureCardDisplay];
}

- (void)slideCardsIfNeededAnimated:(BOOL)animated
{
    for (int i = 0; i < self.cardViews.count - 1; i++) {
        [self slideCardIfNeededAtIndex:i animated:animated];
    }
}

- (void)slideCardIfNeededAtIndex:(NSInteger)index animated:(BOOL)animated
{
    SlidingCardView *card = self.cardViews[index];
    [card slideToShowIndex:[self currentIndex] animated:animated];
}

- (NSInteger)currentIndex
{
    return floor((self.normalizedContentOffset - self.contentOffset.y + 1) / IMAGE_OFFSET);
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isConfiguringCardDisplay) {
        [self slideCardsIfNeededAnimated:YES];
        self.highlightedCardIndex = self.currentIndex;
    }
}

#pragma mark - SlidingImageViewDelegate methods

- (void)cardRemoved:(Card *)cardRemoved
{
    // Removes a single card instead of all equal instances
    [self.cardStack.cards removeObjectAtIndex:[self.cardStack.cards indexOfObject:cardRemoved]];
    
    [self.stackedCardViewDelegate didRemoveCard:cardRemoved fromStack:self.cardStack];
    
    if (self.cardStack.cards.count == 0 && [self.stackedCardViewDelegate respondsToSelector:@selector(stackedViewDidEmpty)]) {
        [self.stackedCardViewDelegate stackedViewDidEmpty];
    } else {
        [self reloadStack];
    }
}

#pragma mark - configure methods


- (void)configureCardDisplay
{
    self.configuringCardDisplay = YES;
    self.cardViews = [NSMutableArray new];
    
    for (NSInteger i = self.cardStack.cards.count - 1; i >= 0; i--) {
        Card *card = self.cardStack.cards[i];
        [self configureCardInStack:card atIndex:i];
    }
    
    [self configureContentSizeToHeightOfStackedImages];
    [self configureNormalizedOffset];
    
    [self highlightedImageDisplayed];
    self.configuringCardDisplay = NO;
}

- (void)configureCardInStack:(Card *)card atIndex:(NSInteger)index
{
    SlidingCardView *slidingImageView = [[SlidingCardView alloc] initWithCard:card];
    
    [slidingImageView setImageWithURL:card.smallImageURL placeholderImage:self.cardBack];
    slidingImageView.delegate = self;
    slidingImageView.index = index;
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

- (void)highlightedImageDisplayed
{
    [self setContentOffset:CGPointMake(0, self.normalizedContentOffset - self.highlightedCardIndex * IMAGE_OFFSET) animated:NO];
    [self slideCardsIfNeededAnimated:NO];
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
