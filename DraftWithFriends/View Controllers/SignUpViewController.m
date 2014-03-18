//
//  SignupViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "SignupViewController.h"
#import "MTGUser.h"
#import "UserService.h"
#import "PrettyButton.h"
#import "Consts.h"

#define EMAIL_MISSING 200
#define INVALID_EMAIL 125

@interface SignupViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet PrettyButton *signupButton;

@property (nonatomic) MTGUser *user;

@end

@implementation SignupViewController

#pragma mark - IBActions

- (IBAction)signupTapped
{
    [self signUp];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    } else if (textField == self.lastNameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.confirmPasswordTextField becomeFirstResponder];
    } else {
        [self signUp];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self hideErrorMessage];
	return YES;
}

- (void)signUp
{
    NSString *errorMessage = [self isValid];
    
    if (errorMessage) {
        [self showErrorMessage:errorMessage];
        return;
    }
    
    self.signupButton.enabled = NO;
    
    self.user.firstName = self.firstNameTextField.text;
    self.user.lastName = self.lastNameTextField.text;
    self.user.email = self.emailTextField.text;
    self.user.password = self.passwordTextField.text;
    
    [[UserService sharedService] signUpUser:self.user completed:^(id failureObject, id object) {
        if (!failureObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTGUserLogInNotificationKey object:self userInfo:@{MTGUserLogInNotificationKey:self.user}];
        } else {
            if ([failureObject code] == INVALID_EMAIL) {
                [self.emailTextField becomeFirstResponder];
            } else if ([failureObject code] == EMAIL_MISSING) {
                [self.emailTextField becomeFirstResponder];
            }
            [self showErrorMessage:[failureObject userInfo][@"error"]];
        }
        
        self.signupButton.enabled = YES;
    }];
}

- (NSString *)isValid
{
    NSString *errorMessage;
    
    if ([self.firstNameTextField.text isEqualToString:@""]) {
        [self.firstNameTextField becomeFirstResponder];
        errorMessage = @"First name required";
    } else if ([self.lastNameTextField.text isEqualToString:@""]) {
        [self.lastNameTextField becomeFirstResponder];
        errorMessage = @"Last name required";
    } else if ([self.emailTextField.text isEqualToString:@""]) {
        [self.emailTextField becomeFirstResponder];
        errorMessage = @"Email required";
    } else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self.passwordTextField becomeFirstResponder];
        errorMessage = @"Passwords must match";
    } else if (self.passwordTextField.text.length < 6) {
        [self.passwordTextField becomeFirstResponder];
        errorMessage = @"Passwords must be at least 6 characters";
    }
    
    return errorMessage;
}

- (void)setupKeyboard
{
    [super setupKeyboard];
    
    self.firstNameTextField.inputAccessoryView = self.keyboardToolbar;
    self.lastNameTextField.inputAccessoryView = self.keyboardToolbar;
    self.emailTextField.inputAccessoryView = self.keyboardToolbar;
    self.passwordTextField.inputAccessoryView = self.keyboardToolbar;
    self.confirmPasswordTextField.inputAccessoryView = self.keyboardToolbar;
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeyboard];
    
    self.user = [[MTGUser alloc] init];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

@end
