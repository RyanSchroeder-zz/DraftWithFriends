//
//  WireFrameViewController.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WireframeViewController : UIViewController

@property (nonatomic) UIWindow *window;

- (void)logIn;
- (void)logOut;

- (id)initWithWindow:(UIWindow *)window;

@end
