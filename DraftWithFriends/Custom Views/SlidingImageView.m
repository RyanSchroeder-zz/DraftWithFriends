//
//  SlidingImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "SlidingImageView.h"

@implementation SlidingImageView

/**
 @return Yes if the animation occured
 */
- (BOOL)slideDownAnimated:(BOOL)animated
{
    if (floor(self.frame.origin.y) == floor(self.originalY + self.frame.size.height)) {
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
    if (floor(self.frame.origin.y) == floor(self.originalY)) {
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

@end
