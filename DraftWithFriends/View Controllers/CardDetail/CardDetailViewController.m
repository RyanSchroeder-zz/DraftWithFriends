//
//  CardDetailViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/31/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "CardDetailViewController.h"

@interface CardDetailViewController ()

@property (nonatomic) UIView *overlay;
@property (nonatomic) UIImage *cardImage;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation CardDetailViewController

- (id)initWithImage:(UIImage *)image card:(Card *)card
{
    self = [super initWithNibName:@"CardDetail" bundle:nil];
    
    [self setCardImage:image];
    [self setCard:card];
    [self configureTapToDismiss];
    
    return self;
}

- (void)configureTapToDismiss
{
    [self setTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView)]];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)presentModalViewInView:(UIView *)view
{
    [self setOverlay:[[UIView alloc] initWithFrame:view.frame]];
    [self.overlay setBackgroundColor:[UIColor blackColor]];
    [self.overlay setAlpha:0.5];
    [view addSubview:self.overlay];
    
    [self.view setFrame:self.cardImageView.frame];
    [self.view setFrameX:view.frame.size.width / 2 - self.view.frame.size.width / 2];
    [self.view setFrameY:view.frame.size.height / 2 - self.view.frame.size.height / 2];
    [self.cardImageView setImage:self.cardImage];
    [view addSubview:self.view];
}

- (void)dismissModalView
{
    [self.overlay removeFromSuperview];
    [self.view removeFromSuperview];
}

@end
