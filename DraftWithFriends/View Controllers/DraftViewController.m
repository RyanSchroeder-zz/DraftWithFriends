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
#import <SDWebImage/UIImageView+WebCache.h>

NSString * const kDraftCardCellKey = @"draftCardCell";
NSString * const kSetKey = @"ths";

@interface DraftViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSArray *cards;
@property (nonatomic) MTGSet *therosSet;

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
	
    Card *currentCard = self.cards[indexPath.row];
    
    [cell.cardImageView setImageWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"http://magiccards.info/scans/en/%@/%@.jpg", kSetKey, currentCard.numberInSet]]
                       placeholderImage:nil];
    
    return cell;
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

- (void)configureGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTouchesRequired:2];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setCancelsTouchesInView:NO];
    [tapRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) handleTap:(UITapGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self setCards:[self.therosSet generateBoosterPack]];
        [self.collectionView reloadData];
    }
}

#pragma mark - View methods

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureGestureRecognizer];
    [self configureCollectionView];
    [self configureCards];
}

@end
