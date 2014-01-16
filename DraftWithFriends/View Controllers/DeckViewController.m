//
//  DeckViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "DeckViewController.h"
#import "StackedCardCell.h"
#import "StackedImageView.h"
#import "ImageStack.h"

NSString * const kStackedCardCellKey = @"stackedCardCell";

@interface DeckViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *imageStacks;

@end

@implementation DeckViewController

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.imageStacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStackedCardCellKey forIndexPath:indexPath];
	
    ImageStack *imageStack = self.imageStacks[indexPath.row];
    [cell.stackedImageView setVisibleImageIndex:[imageStack visibleImageIndex]];
    [cell.stackedImageView setImageStack:[imageStack images]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *stackedCardCell = (StackedCardCell *)cell;
	
    ImageStack *imageStack = self.imageStacks[indexPath.row];
    imageStack.visibleImageIndex = stackedCardCell.stackedImageView.visibleImageIndex;
}

#pragma mark - configure methods

- (void)configureCards
{
#warning Mock data
    NSMutableArray *fetchedCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < 14; i++) {
        NSString *name = [NSString stringWithFormat:@"%d.jpg", i + 1];
        UIImage *cardImage = [UIImage imageNamed:name];
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
    
    self.imageStacks = @[[[ImageStack alloc] initWithImages:[fetchedCards copy]],
                        [[ImageStack alloc] initWithImages:[fetchedCards2 copy]],
                        [[ImageStack alloc] initWithImages:[fetchedCards3 copy]]];
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
