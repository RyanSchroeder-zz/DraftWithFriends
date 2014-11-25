//
//  StackedImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "StackedImageView.h"
#import "SlidingImageView.h"
#import "ImageStack.h"
#import "Card.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#define IMAGE_OFFSET 27
#define IMAGE_HEIGHT 285
#define IMAGE_WIDTH 200

@interface StackedImageView () <UIScrollViewDelegate, SlidingImageViewDelegate>

@property (nonatomic) ImageStack *cardStack;
@property (nonatomic) NSMutableArray *imageViews;
@property (nonatomic) CGFloat startingContentOffset;
@property (nonatomic, getter = isConfiguringImages) BOOL configuringImages;
@property (nonatomic) UIImage *cardBack;

@end

@implementation StackedImageView

- (void)setCardStack:(ImageStack *)cardStack
{
    _cardStack = cardStack;
    
    [self reloadStack];
}

- (void)reloadStack
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configureImages];
    [self scrollToHighlightedImage];
}

- (void)scrollToHighlightedImage
{
    [self setContentOffset:CGPointMake(0, self.startingContentOffset - self.visibleImageIndex * IMAGE_OFFSET) animated:NO];
    [self slideImagesIfNeededAnimated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.visibleImageIndex == 0 && self.isConfiguringImages) {
        self.configuringImages = NO;
        return;
    }
    
    [self preventDownScrollIfOnLastCard:scrollView.contentOffset.y];
    
    if (self.isConfiguringImages) {
        [self slideImagesIfNeededAnimated:NO];
        self.configuringImages = NO;
    } else {
        [self slideImagesIfNeededAnimated:YES];
    }
}

- (void)preventDownScrollIfOnLastCard:(CGFloat)scrollViewY
{
    CGFloat lastCardY = self.startingContentOffset - self.imageViews.count * IMAGE_OFFSET;
    if (scrollViewY < lastCardY) {
        [self setContentOffset:CGPointMake(0, lastCardY + 1) animated:NO];
    }
}

- (void)slideImagesIfNeededAnimated:(BOOL)animated
{
    for (int i = 0; i < self.imageViews.count; i++) {
        [self slideImageIfNeededAtIndex:i animated:animated];
    }
}

- (void)slideImageIfNeededAtIndex:(NSInteger)index animated:(BOOL)animated
{
    SlidingImageView *image = self.imageViews[index];
    
    NSInteger offset = floor((self.startingContentOffset - self.contentOffset.y) / IMAGE_OFFSET);
    BOOL slideAnimationDidOccur = NO;
    
    if (offset > index && index != self.imageViews.count - 1) {
        slideAnimationDidOccur = [image slideDownAnimated:animated];
    } else if (offset < index) {
        slideAnimationDidOccur = [image slideUpAnimated:animated];
    }
    
    if (offset <= 0) {
        offset = 0;
    } else if (offset >= self.imageViews.count) {
        offset = self.imageViews.count - 1;
    }
    
    if (slideAnimationDidOccur) {
        self.visibleImageIndex = offset;
    }
}

#pragma mark - SlidingImageViewDelegate methods

- (void)cardRemoved:(Card *)card
{
    NSMutableArray *cards = [self.cardStack.cards mutableCopy];
    
    for (NSInteger i = 0; i < cards.count; i++) {
        if (cards[i] == card) {
            [cards removeObjectAtIndex:i];
            break;
        }
    }
    
    self.cardStack.cards = [cards copy];
    
    [self.stackedImageViewDelegate didRemoveCard:card fromStack:self.cardStack];
    
    if (cards.count == 0 && [self.stackedImageViewDelegate respondsToSelector:@selector(stackedViewDidEmpty)]) {
        [self.stackedImageViewDelegate stackedViewDidEmpty];
    } else {
        [self reloadStack];
    }
}

#pragma mark - configure methods

- (void)configureImages
{
    self.configuringImages = YES;
    self.imageViews = [NSMutableArray new];
    
    for (NSInteger i = self.cardStack.cards.count - 1; i >= 0; i--) {
        Card *card = self.cardStack.cards[i];
        [self configureCardInStack:card atIndex:i];
    }
    
    [self configureContentSizeToHeightOfStackedImages];
    [self configureStartintContentOffset];
}

- (void)configureCardInStack:(Card *)card atIndex:(NSInteger)index
{
    SlidingImageView *slidingImageView = [[SlidingImageView alloc] initWithCard:card];
    
    [slidingImageView setImageWithURL:card.smallImageURL placeholderImage:self.cardBack];
    slidingImageView.delegate = self;
    slidingImageView.originalY = (self.cardStack.cards.count - index) * IMAGE_OFFSET;
    slidingImageView.frame = [self cardFrameAtY:slidingImageView.originalY];
    
    [self.imageViews insertObject:slidingImageView atIndex:0];
    [self addSubview:slidingImageView];
}

- (CGRect)cardFrameAtY:(CGFloat)yCoordinate
{
    return CGRectMake(0, yCoordinate, self.frame.size.width, self.frame.size.width * IMAGE_HEIGHT / IMAGE_WIDTH);
}

- (void)configureContentSizeToHeightOfStackedImages
{
    self.contentSize = CGSizeMake(self.frame.size.width,
                                  [self.imageViews[0] size].height * 2 + ((self.cardStack.cards.count + 1) * IMAGE_OFFSET));
}

- (void)configureStartintContentOffset
{
    self.startingContentOffset = self.contentSize.height - self.frame.size.height;
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
