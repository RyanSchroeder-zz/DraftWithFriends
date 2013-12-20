//
//  DraftViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Ryan Schroeder. All rights reserved.
//

#import "DraftViewController.h"
#import "DraftCardCell.h"

NSString * const kDraftCardCellKey = @"draftCardCell";

@interface DraftViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *cards;

@end

@implementation DraftViewController

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DraftCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDraftCardCellKey forIndexPath:indexPath];
	
    NSLog(@"card %d", indexPath.row);
    cell.cardImageView = self.cards[indexPath.row];
    
    return cell;
}
#pragma mark - configure methods

- (void)configureCards
{
#warning Mock data
    NSMutableArray *fetchedCards = [[NSMutableArray alloc] init];
    for (int i = 0; i < 14; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]]];
        [fetchedCards addObject:imageView];
    }
    
    self.cards = [fetchedCards copy];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCards];
    [self configureCollectionView];
}

@end
