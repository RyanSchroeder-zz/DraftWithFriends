//
//  SetPickerViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/6/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "SetPickerViewController.h"
#import "MTGSetService.h"
#import "DraftViewController.h"
#import "UserService.h"

@interface SetPickerViewController () <DraftViewControllerDelegate>

@property (nonatomic) MTGSet *set;

@end

@implementation SetPickerViewController

- (IBAction)bornOfTheGodsTapped
{
    [[MTGSetService sharedService] setWithSetCode:@"BNG" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)therosTapped
{
    [[MTGSetService sharedService] setWithSetCode:@"THS" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)m14Tapped
{
    [[MTGSetService sharedService] setWithSetCode:@"M14" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)dragonsMazeTapped
{
    [[MTGSetService sharedService] setWithSetCode:@"DGM" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)gatecrashTapped
{
    [[MTGSetService sharedService] setWithSetCode:@"GTC" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)returnToRavnicaTapped
{
    [[MTGSetService sharedService] setWithSetCode:@"RTR" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)m13Tapped
{
    [[MTGSetService sharedService] setWithSetCode:@"M13" callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraft" sender:self];
    }];
}

- (IBAction)logoutTapped
{
    [[UserService sharedService] logOut];
}

#pragma mark - DraftViewControllerDelegate methods

- (void)newDraftDesired
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - configure methods

- (void)configureStyles
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - View Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDraft"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setCardSet:self.set];
        [segue.destinationViewController setCards:[self.set generateBoosterPack]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureStyles];
}

@end
