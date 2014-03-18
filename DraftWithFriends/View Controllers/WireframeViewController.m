//
//  WireFrameViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "WireframeViewController.h"
#import "WelcomeViewController.h"
#import "SetPickerViewController.h"
#import "UserService.h"


@interface WireframeViewController ()

@end

@implementation WireframeViewController

#pragma mark - public methods

- (void)logIn
{
    [self presentLoggedInViewController];
}

- (void)logOut
{
    [self presentWelcomeViewController];
}

#pragma mark - present view controller methods

- (void)presentLoggedInViewController
{
    SetPickerViewController *setPickerViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPickerViewController"];
    UINavigationController *appEntryNavController = [[UINavigationController alloc] initWithRootViewController:setPickerViewController];
    [appEntryNavController setNavigationBarHidden:YES];
    self.window.rootViewController = appEntryNavController;
}

- (void)presentWelcomeViewController
{
    WelcomeViewController *welcomeViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    UINavigationController *appEntryNavController = [[UINavigationController alloc] initWithRootViewController:welcomeViewController];
    self.window.rootViewController = appEntryNavController;
}

#pragma mark - view methods

- (id)init
{
    NSAssert(0, @"Use default initializer");
    return nil;
}

- (id)initWithWindow:(UIWindow *)window
{
    self = [super init];
    
    if (self) {
        self.window = window;
        
        MTGUser *user = [[UserService sharedService] currentUser];
        if (user) {
            [self presentLoggedInViewController];
        } else {
            [self presentWelcomeViewController];
        }
        
        [window makeKeyAndVisible];
    }
    
    return self;
}

@end
