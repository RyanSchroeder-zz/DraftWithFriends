//
//  LoginViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "LoginViewController.h"
#import "UserService.h"
#import "PrettyButton.h"
#import "Consts.h"
#import "MTGUser.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic) MTGUser *user;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet PrettyButton *loginButton;

@end

@implementation LoginViewController

#pragma mark - IBActions

- (IBAction)loginTapped
{
    NSLog(@"Yo");
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self logIn];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self hideErrorMessage];
	return YES;
}

#pragma mark - login logic

- (IBAction)logInTapped
{
    [self logIn];
}

- (void)logIn
{
    self.user.email = self.emailTextField.text;
    self.user.password = self.passwordTextField.text;
    self.loginButton.enabled = NO;
    
    [[UserService sharedService] logInUser:self.user completed:^(id failureObject, id object) {
        if (!failureObject) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTGUserLogInNotificationKey object:self userInfo:nil];
        } else {
            [self.emailTextField becomeFirstResponder];
            [self showErrorMessage:[failureObject userInfo][@"error"]];
        }
        
        self.loginButton.enabled = YES;
    }];
}

- (void)setupKeyboard
{
    [super setupKeyboard];
    
    self.emailTextField.inputAccessoryView = self.keyboardToolbar;
    self.passwordTextField.inputAccessoryView = self.keyboardToolbar;
}

#pragma mark - view methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupKeyboard];
    
    self.emailTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:kEmailKey];
    
    self.user = [[MTGUser alloc] init];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

@end
