//
//  ViewController.m
//  DraftWithFriends
//
//  Created by Ryan Schroeder on 9/11/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UIGestureRecognizerDelegate>
    @property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
    @property (strong, nonatomic) NSArray *cardsInSet;
    @property (strong, nonatomic) Card *currentlyDisplayedCard;
    @property (strong, nonatomic) NSString *currentlySelectedSetName;
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
    
    if (![self.currentlyDisplayedCard.number isEqualToString:firstCard.number])
    {
        [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:[self.currentlyDisplayedCard.number intValue] - 2]];
        [self setImageForCurrentCard];
    }
}

- (void)handleCardSwipeLeft:(UIGestureRecognizer *)recognizer
{
    Card *lastCard = [self.cardsInSet lastObject];
    
    if (![self.currentlyDisplayedCard.number isEqualToString:lastCard.number])
    {
        [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:[self.currentlyDisplayedCard.number intValue]]];
        [self setImageForCurrentCard];
    }
}

- (IBAction)LoadM14Pressed:(id)sender
{
    [self fetchSetJSON:@"M14"];
}

- (IBAction)LoadM13Pressed:(id)sender
{
    [self fetchSetJSON:@"M13"];
}

- (IBAction)LoadRTRPressed:(id)sender
{
    [self fetchSetJSON:@"RTR"];
}

- (IBAction)LoadGTCPressed:(id)sender
{
    [self fetchSetJSON:@"GTC"];
}

- (IBAction)DGM:(id)sender
{
    [self fetchSetJSON:@"DGM"];
}

- (void)fetchSetJSON:(NSString *)setName
{
    json_load_dispatch_group = dispatch_group_create();
    
    NSString *setPath = [[[NSBundle mainBundle] URLForResource:setName withExtension:@"json"] path];
    
    NSAssert(setPath, @"Couldn't find the set in the main bundle");
    
    dispatch_group_async(json_load_dispatch_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:setPath]
                                                  options:0
                                                    error:&jsonError];
        __JSONLoadingError = jsonError;
        
        if (!jsonError) {
            NSMutableArray *mutableCardsInSet = [[NSMutableArray alloc] init];
            for (id cardJSON in [json valueForKey:@"cards"]) {
                Card *currentCard = [Card cardWithDictionary:cardJSON];
                [mutableCardsInSet addObject:currentCard];
            }
            [self setCardsInSet:[mutableCardsInSet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int firstNumber = [((Card *)a).number integerValue];
                int secondNumber = [((Card *)b).number integerValue];
                
                return firstNumber >= secondNumber ? NSOrderedDescending : NSOrderedAscending;
            }]];
            
            [self setCurrentlySelectedSetName:[setName lowercaseString]];
            
            [self setCurrentlyDisplayedCard:[self.cardsInSet objectAtIndex:0]];
            [self setImageForCurrentCard];
        }
    });
}

- (void)setImageForCurrentCard
{
    [self.cardImageView setImageWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", self.currentlySelectedSetName, self.currentlyDisplayedCard.number]]
                       placeholderImage:nil];
}

@end
