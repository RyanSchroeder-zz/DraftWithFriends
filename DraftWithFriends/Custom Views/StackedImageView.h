//
//  StackedImageView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageStack;

@protocol StackedImageViewDelegate <NSObject>

- (void)stackedViewDidEmpty;

@end

@interface StackedImageView : UIScrollView

@property (nonatomic) id<StackedImageViewDelegate> stackedImageViewDelegate;
@property (nonatomic) NSInteger visibleImageIndex;

- (void)setImageStack:(ImageStack *)imageStack;

@end
