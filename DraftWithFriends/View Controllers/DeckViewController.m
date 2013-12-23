//
//  DeckViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "DeckViewController.h"
#import "StackedCardCell.h"
#import "StackedCardView.h"

NSString * const kStackedCardCellKey = @"stackedCardCell";

@interface DeckViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *cardStacks;

@end

@implementation DeckViewController

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.cardStacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStackedCardCellKey forIndexPath:indexPath];
	
#warning be able to set the visible card
    [cell.stackedCardView setCardStack:self.cardStacks[indexPath.row]];
    
    return cell;
}
#pragma mark - configure methods

- (void)configureCards
{
#warning Mock data
    NSMutableArray *fetchedCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < 14; i++) {
        UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        [fetchedCards addObject:cardImage];
    }
    NSMutableArray *fetchedCards2 = [[NSMutableArray alloc] init];
    for (int i = 13; i > 0; i--) {
        UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        [fetchedCards2 addObject:cardImage];
    }
    NSMutableArray *fetchedCards3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        UIImage *cardImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        [fetchedCards3 addObject:cardImage];
    }
    
    self.cardStacks = @[[fetchedCards copy], [fetchedCards2 copy], [fetchedCards3 copy]];
    [self.collectionView reloadData];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - View methods

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
