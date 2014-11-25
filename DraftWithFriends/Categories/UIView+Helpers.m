//
//  UIView+Helpers.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "UIView+Helpers.h"

@implementation UIView (Helpers)

- (void)setFrameX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setFrameHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

@end
