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

@property (nonatomic) NSArray *cards;
@property (nonatomic) MTGSet *therosSet;
@property (nonatomic) NSMutableArray *picks;

@end

@implementation DraftViewController

- (NSMutableArray *)picks
{
    if (!_picks) {
        _picks = [NSMutableArray new];
    }
    
    return _picks;
}

#pragma mark - DeckViewControllerDelegate methods

- (void)returnToDraftView
{
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
    
    [self setCards:[self.therosSet generateBoosterPack]];
    [self.collectionView reloadData];
}

#pragma mark - configure methods

- (void)configureCards
{
    [[MTGSetService sharedService] setWithSetCode:@"THS" callback:^(NSError *error, MTGSet *set) {
        [self setTherosSet:set];
        [self setCards:[set generateBoosterPack]];
        [self.collectionView reloadData];
    }];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureCards];
}

@end
