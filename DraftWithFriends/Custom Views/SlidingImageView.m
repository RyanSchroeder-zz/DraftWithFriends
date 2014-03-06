//
//  SlidingImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "SlidingImageView.h"

@implementation SlidingImageView

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    return self;
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

- (BOOL)float:(CGFloat)float1 isCloseToFloat:(CGFloat)float2
{
    int f1 = (int)floor(float1);
    int f2 = (int)floor(float2);
    
    return (f1 <= f2 + 1) && (f1 >= f2 - 1);
}

@end
