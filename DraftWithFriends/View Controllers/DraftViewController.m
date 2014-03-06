//
//  DraftViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "DraftViewController.h"
#import "DraftCardCell.h"
#import "MTGSetService.h"
#import "DeckViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const kDraftCardCellKey = @"draftCardCell";
NSString * const kSetKey = @"ths";

@interface DraftViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, DeckViewControllerDelegate>

@property (nonatomic) NSMutableArray *picks;
@property (weak, nonatomic) IBOutlet UIButton *picksButton;

@end

@implementation DraftViewController

- (NSMutableArray *)picks
{
    if (!_picks) {
        _picks = [NSMutableArray new];
    }
    
    return _picks;
}

#pragma mark - IBAction methods

- (IBAction)newDraftButtonTapped
{
    [self.delegate newDraftDesired];
}


#pragma mark - DeckViewControllerDelegate methods

- (void)returnToDraftView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetPicks
{
    self.picks = nil;
    [self setCards:[self.cardSet generateBoosterPack]];
    [self.collectionView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DraftCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDraftCardCellKey forIndexPath:indexPath];
	
    Card *currentCard = self.cards[indexPath.row];
    
    [cell.cardImageView setImageWithURL:currentCard.smallImageURL placeholderImage:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.picks addObject:self.cards[indexPath.row]];
    self.picksButton.hidden = NO;
    
    NSInteger boosterPackSize = [[MTGSetService sharedService] boosterPackSize];
    
    if (self.picks.count < boosterPackSize * 3) {
        [self setCards:[self.cardSet generateBoosterPackMinus:self.picks.count % boosterPackSize]];
        [self.collectionView reloadData];
    } else {
        [self performSegueWithIdentifier:@"showPicks" sender:self];
    }
}

#pragma mark - configure methods

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)configurePicksButton
{
    if (!self.picks || self.picks.count == 0) {
        self.picksButton.hidden = YES;
    }
}

#pragma mark - View methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPicks"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setPicks:[self.picks copy]];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configurePicksButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
}

@end
