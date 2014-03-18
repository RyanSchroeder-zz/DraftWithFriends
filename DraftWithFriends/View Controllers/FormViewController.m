//
//  FormViewController.m
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/24/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController


#pragma mark - validation


- (void)setupKeyboard
{
	self.keyboardToolbar = [self toolbarForKeyboard];
	
	self.errorMessageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	self.errorMessageContainer.backgroundColor = [UIColor whiteColor];
	self.errorMessageContainer.alpha = 0;
	
	self.errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 10, 44)];
	self.errorMessage.backgroundColor = [UIColor whiteColor];
	self.errorMessage.textColor = [UIColor redColor];
	self.errorMessage.font = [self.errorMessage.font fontWithSize:12];
	self.errorMessage.lineBreakMode = NSLineBreakByWordWrapping;
	self.errorMessage.numberOfLines = 0;
	
	[self.errorMessageContainer addSubview:self.errorMessage];
	
	[self.keyboardToolbar addSubview:self.errorMessageContainer];
    
    self.keyboardToolbar.hidden = YES;
}

- (UIToolbar *)toolbarForKeyboard
{
	self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
	return self.keyboardToolbar;
}

- (void)showErrorMessage:(NSString *)errorMessage
{
	self.errorMessage.text = errorMessage;
	[UIView animateWithDuration:0.3 animations:^{
		self.errorMessageContainer.alpha = 1;
        self.keyboardToolbar.hidden = NO;
	}];
}

- (void)hideErrorMessage
{
	[UIView animateWithDuration:0.3 animations:^{
		self.errorMessageContainer.alpha = 0;
        self.keyboardToolbar.hidden = YES;
	}];
}

@end
