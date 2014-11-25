//
//  WireFrameViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "WireframeViewController.h"
#import "SetPickerViewController.h"
#import "UserService.h"


@interface WireframeViewController ()

@end

@implementation WireframeViewController

#pragma mark - present view controller methods

- (void)presentMagicSetsList
{
    SetPickerViewController *setPickerViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"SetPickerViewController"];
    UINavigationController *appEntryNavController = [[UINavigationController alloc] initWithRootViewController:setPickerViewController];
    [appEntryNavController setNavigationBarHidden:YES];
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
        
        [self presentMagicSetsList];
        
        [window makeKeyAndVisible];
    }
    
    return self;
}

@end
