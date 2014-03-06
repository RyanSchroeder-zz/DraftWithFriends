//
//  StackedImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageStack;

@interface StackedImageView : UIScrollView

@property (nonatomic) NSInteger visibleImageIndex;

- (void)setImageStack:(ImageStack *)imageStack;

@end
