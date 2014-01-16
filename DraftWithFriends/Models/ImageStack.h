//
//  ImageStack.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 1/16/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStack : NSObject

@property (nonatomic) NSArray *images;
@property (nonatomic) NSInteger visibleImageIndex;

- (id)initWithImages:(NSArray *)images;

@end
