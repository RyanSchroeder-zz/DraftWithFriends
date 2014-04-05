//
//  ShareDeckView.h
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 4/4/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyButton.h"

@protocol ShareDeckViewDelegate <NSObject>

- (void)didTapShare;

@end

@interface ShareDeckView : UIView

@property (nonatomic) id<ShareDeckViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet PrettyButton *shareButton;

@end
