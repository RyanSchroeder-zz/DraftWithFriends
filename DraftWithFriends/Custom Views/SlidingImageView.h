//
//  SlidingImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/22/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingImageView : UIImageView

@property (nonatomic) CGFloat originalY;

- (id)initWithImage:(UIImage *)image;
- (BOOL)slideDownAnimated:(BOOL)animated;
- (BOOL)slideUpAnimated:(BOOL)animated;

@end
