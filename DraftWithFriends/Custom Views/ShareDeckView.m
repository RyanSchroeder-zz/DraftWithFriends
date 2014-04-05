//
//  ShareDeckView.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 4/4/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "ShareDeckView.h"

@interface ShareDeckView () <UITextFieldDelegate>

@end

@implementation ShareDeckView

- (IBAction)shareTapped
{
    [self.delegate didTapShare];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self shareTapped];
    return YES;
}

#pragma mark - view methods

- (void)awakeFromNib
{
    self.emailTextField.delegate = self;
}

- (id)init
{
    UINib *nib = [UINib nibWithNibName:@"ShareDeckView" bundle:nil];
    
    NSArray *nibArray = [nib instantiateWithOwner:self options:nil];
    NSAssert([nibArray count], @"Unarchived nib was empty?");
    
    id view = nibArray[0];
    
    return view;
}

@end
