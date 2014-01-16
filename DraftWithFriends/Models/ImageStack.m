//
//  ImageStack.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 1/16/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "ImageStack.h"

@implementation ImageStack

- (id)initWithImages:(NSArray *)images
{
    self = [super init];
    
    if (self) {
        self.images = images;
        self.visibleImageIndex = 0;
    }
    
    return self;
}

@end
