//
//  LandPickerView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "LandPickerView.h"

@implementation LandPickerView

- (IBAction)doneButtonTapped
{
    [self.delegate donePickingLands];
}

- (IBAction)swampStepperChanged
{
    [self.swampLabel setText:[NSString stringWithFormat:@"Swamp: %d", (int)self.swampStepper.value]];
}

- (IBAction)mountainStepperChanged
{
    [self.mountainLabel setText:[NSString stringWithFormat:@"Mountain: %d", (int)self.mountainStepper.value]];
}

- (IBAction)plainsStepperChanged
{
    [self.plainsLabel setText:[NSString stringWithFormat:@"Plains: %d", (int)self.plainsStepper.value]];
}

- (IBAction)islandStepperChanged
{
    [self.islandLabel setText:[NSString stringWithFormat:@"Island: %d", (int)self.islandStepper.value]];
}

- (IBAction)forestStepperChanged
{
    [self.forestLabel setText:[NSString stringWithFormat:@"Forest: %d", (int)self.forestStepper.value]];
}

@end