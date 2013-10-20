//
//  ViewController.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import "CardRepository.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

@interface ViewController () <UIGestureRecognizerDelegate>
    @property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
    @property (strong, nonatomic) NSArray *cardsInSet;
    @property (strong, nonatomic) Card *currentlyDisplayedCard;
    @property (strong, nonatomic) NSString *currentlySelectedSetCode;
@end

static dispatch_group_t json_load_dispatch_group;
static NSDictionary *__M14Dictionary;
static NSError *__JSONLoadingError;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCardSwipeGestureRecognizers];
}

- (void)setupCardSwipeGestureRecognizers
{
    [self.cardImageView setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *cardSwipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardSwipeLeft:)];
    [cardSwipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [cardSwipeLeftGestureRecognizer setDelegate:self];
    [self.cardImageView addGestureRecognizer:cardSwipeLeftGestureRecognizer];
    
    UISwipeGestureRecognizer *cardSwipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleCardSwipeRight:)];
    [cardSwipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [cardSwipeRightGestureRecognizer setDelegate:self];
    [self.cardImageView addGestureRecognizer:cardSwipeRightGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleCardSwipeRight:(UIGestureRecognizer *)recognizer
{
    Card *firstCard = [self.cardsInSet firstObject];
    
    if (![self.currentlyDisplayedCard.numberInSet isEqualToString:firstCard.numberInSet])
    {
        [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:[self.currentlyDisplayedCard.numberInSet intValue] - 2]];
        [self setImageForCurrentCard];
    }
}

- (void)handleCardSwipeLeft:(UIGestureRecognizer *)recognizer
{
    Card *lastCard = [self.cardsInSet lastObject];
    
    if (![self.currentlyDisplayedCard.numberInSet isEqualToString:lastCard.numberInSet])
    {
        [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:[self.currentlyDisplayedCard.numberInSet intValue]]];
        [self setImageForCurrentCard];
    }
}

- (IBAction)LoadM14Pressed:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [self fetchSetJSON:@"M14"];
}

- (IBAction)LoadM13Pressed:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [self fetchSetJSON:@"M13"];
}

- (IBAction)LoadRTRPressed:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [self fetchSetJSON:@"RTR"];
}

- (IBAction)LoadGTCPressed:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [self fetchSetJSON:@"GTC"];
}

- (IBAction)DGM:(id)sender
{
    [[SDImageCache sharedImageCache] clearMemory];
    [self fetchSetJSON:@"DGM"];
}

- (void)fetchSetJSON:(NSString *)setCode
{
    CardRepository *cardRepository = [CardRepository initializeRepositoryForSet:setCode];
    [cardRepository cardsWithSuccess:^(NSArray *cardsInSet) {
        [self setCardsInSet:cardsInSet];
    } failure:nil];
    
    [self setCurrentlySelectedSetCode:[setCode lowercaseString]];
    [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:0]];
    [self setImageForCurrentCard];
}

- (void)setImageForCurrentCard
{
    [self.cardImageView setImageWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", self.currentlySelectedSetCode, self.currentlyDisplayedCard.numberInSet]]
                       placeholderImage:nil];
}

@end
