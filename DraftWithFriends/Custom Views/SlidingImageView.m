//
//  SlidingImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "SlidingImageView.h"
#import "Card.h"

@interface SlidingImageView () <UIGestureRecognizerDelegate>

@property (nonatomic) Card *card;

@end

@implementation SlidingImageView

- (id)initWithImage:(UIImage *)image andCard:(Card *)card
{
    self = [super initWithImage:image];
    
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

/**
 @return Yes if the animation occured
 */
- (BOOL)slideDownAnimated:(BOOL)animated
{
    if ([self float:self.frame.origin.y isCloseToFloat:self.originalY + self.frame.size.height]) {
        return NO;
    }

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
    if ([self float:self.frame.origin.y isCloseToFloat:self.originalY]) {
        return NO;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrameY:self.originalY];
        }];
    } else {
        [self setFrameY:self.originalY];
    }
    
    return YES;
}

/**
 Testing to see if they were equal caused a few issues and it doesn't need to 
 be an exact match.
 */
- (BOOL)float:(CGFloat)float1 isCloseToFloat:(CGFloat)float2
{
    int f1 = (int)floor(float1);
    int f2 = (int)floor(float2);
    
    return (f1 <= f2 + 1) && (f1 >= f2 - 1);
}

@end
