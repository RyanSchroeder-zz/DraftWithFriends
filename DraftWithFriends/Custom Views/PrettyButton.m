//
//  PrettyButton.m
//  WestCoastCamps
//
//  Created by Trent Ellingsen on 11/24/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "PrettyButton.h"
#import "Consts.h"

@interface PrettyButton ()

@property (nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation PrettyButton

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        self.backgroundColor = MTG_DRAFT_COLOR;
    } else {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.spinner.frame = CGRectMake(self.frame.size.width - 30, self.frame.size.height / 2 - self.spinner.frame.size.height / 2, self.spinner.frame.size.width, self.spinner.frame.size.height);
        [self.spinner startAnimating];
        
        [self addSubview:self.spinner];
        
        self.backgroundColor = [UIColor grayColor];
    }
}

@end
