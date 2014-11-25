//
//  SlidingImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "SlidingCardView.h"
#import "Card.h"

@interface SlidingCardView () <UIGestureRecognizerDelegate>

@property (nonatomic) Card *card;

@end

@implementation SlidingCardView

- (id)initWithCard:(Card *)card
{
    self = [super init];
    
    if (self) {
        self.card = card;
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardRemoved:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
    return self;
}

- (void)cardRemoved:(UITapGestureRecognizer *)recognizer
{
	if ((recognizer.state == UIGestureRecognizerStateChanged) ||
		(recognizer.state == UIGestureRecognizerStateEnded)) {
        [self.delegate cardRemoved:self.card];
    }
}

- (void)slideToShowIndex:(NSInteger)index animated:(BOOL)animated;
{
    if (self.index >= index) {
        [self slideUpAnimated:animated];
    } else {
        [self slideDownAnimated:animated];
    }
}

/**
 @return Yes if the animation occured
 */
- (BOOL)slideDownAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrameY:self.originalY + self.frame.size.height];
        }];
    } else {
        [self setFrameY:self.originalY + self.frame.size.height];
    }
    
    return YES;
}

/**
 @return Yes if the animation occured
 */
- (BOOL)slideUpAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrameY:self.originalY];
        }];
    } else {
        [self setFrameY:self.originalY];
    }
    
    return YES;
}

@end
