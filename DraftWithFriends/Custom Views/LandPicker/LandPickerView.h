//
//  LandPickerView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LandPickerViewDelegate <NSObject>

- (void)donePickingLands;

@end

@interface LandPickerView : UIView

@property (weak, nonatomic) IBOutlet UIStepper *swampStepper;
@property (weak, nonatomic) IBOutlet UIStepper *mountainStepper;
@property (weak, nonatomic) IBOutlet UIStepper *plainsStepper;
@property (weak, nonatomic) IBOutlet UIStepper *islandStepper;
@property (weak, nonatomic) IBOutlet UIStepper *forestStepper;

@property (weak, nonatomic) IBOutlet UILabel *swampLabel;
@property (weak, nonatomic) IBOutlet UILabel *mountainLabel;
@property (weak, nonatomic) IBOutlet UILabel *plainsLabel;
@property (weak, nonatomic) IBOutlet UILabel *islandLabel;
@property (weak, nonatomic) IBOutlet UILabel *forestLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic) id<LandPickerViewDelegate> delegate;

- (IBAction)doneButtonTapped;
- (IBAction)swampStepperChanged;
- (IBAction)mountainStepperChanged;
- (IBAction)plainsStepperChanged;
- (IBAction)islandStepperChanged;
- (IBAction)forestStepperChanged;

@end
