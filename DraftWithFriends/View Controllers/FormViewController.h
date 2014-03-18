//
//  FormViewController.h
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/24/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UITableViewController

@property (nonatomic) UIToolbar *keyboardToolbar;
@property (nonatomic) UIView *errorMessageContainer;
@property (nonatomic) UILabel *errorMessage;

- (void)setupKeyboard;
- (void)showErrorMessage:(NSString *)errorMessage;
- (void)hideErrorMessage;

@end
