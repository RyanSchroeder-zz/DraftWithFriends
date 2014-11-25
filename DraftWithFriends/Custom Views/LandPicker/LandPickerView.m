//
//  LandPickerView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
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
    [self updateTotal];
}

- (IBAction)mountainStepperChanged
{
    [self.mountainLabel setText:[NSString stringWithFormat:@"Mountain: %d", (int)self.mountainStepper.value]];
    [self updateTotal];
}

- (IBAction)plainsStepperChanged
{
    [self.plainsLabel setText:[NSString stringWithFormat:@"Plains: %d", (int)self.plainsStepper.value]];
    [self updateTotal];
}

- (IBAction)islandStepperChanged
{
    [self.islandLabel setText:[NSString stringWithFormat:@"Island: %d", (int)self.islandStepper.value]];
    [self updateTotal];
}

- (IBAction)forestStepperChanged
{
    [self.forestLabel setText:[NSString stringWithFormat:@"Forest: %d", (int)self.forestStepper.value]];
    [self updateTotal];
}

- (void)updateTotal
{
    [self.totalLabel setText:[NSString stringWithFormat:@"Total: %ld", (long)[self totalLands]]];
}

- (NSInteger)totalLands
{
    return (int)(self.swampStepper.value + self.mountainStepper.value + self.plainsStepper.value + self.islandStepper.value + self.forestStepper.value);
}

@end
