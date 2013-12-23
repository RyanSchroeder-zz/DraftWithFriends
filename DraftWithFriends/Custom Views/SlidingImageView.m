//
//  SlidingImageView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "SlidingImageView.h"

@implementation SlidingImageView

- (void)slideDown
{
    [self setFrameY:self.originalY + self.frame.size.height];
}

- (void)slideUp
{
    [self setFrameY:self.originalY];
}

@end
