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
#import "DeckViewModel.h"
#import "ImageStack.h"
#import "MTGSetService.h"

NSString * const kStackedCardCellKey = @"stackedCardCell";

@interface DeckViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackedImageViewDelegate>

// Raw data for the deck
@property (nonatomic) DeckViewModel *deckViewModel;

// The way the data needs to be stored for the view
@property (nonatomic) NSArray *imageStacks;

@property (weak, nonatomic) IBOutlet UIButton *draftButton;
@property (weak, nonatomic) IBOutlet UIButton *addLandsButton;
@property (nonatomic) BOOL isRemovingEmptyStack;

@end

@implementation DeckViewController

- (DeckViewModel *)deckViewModel
{
    if (!_deckViewModel) {
        _deckViewModel = [DeckViewModel new];
    }
    
    return _deckViewModel;
}

- (void)setPicks:(NSArray *)picks
{
    if (_picks != picks) {
        _picks = picks;
        self.deckViewModel.picks = picks;
    }
}

#pragma mark - StackedImageViewDelegate methods

- (void)stackedViewDidEmpty
{
    self.isRemovingEmptyStack = YES;
    NSMutableArray *mutableStacks = [self.imageStacks mutableCopy];
    
    for (ImageStack *imageStack in self.imageStacks) {
        if (imageStack.cards.count == 0) {
            [mutableStacks removeObject:imageStack];
            break;
        }
    }
    
    self.imageStacks = [mutableStacks copy];
    
    [self setVisibleImages];
    
    [self.collectionView reloadData];
    self.isRemovingEmptyStack = NO;
}

- (void)setVisibleImages
{
    for (NSInteger i = 0; i < self.imageStacks.count; i++) {
        StackedCardCell *stackedCardCell = (StackedCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        ImageStack *imageStack = self.imageStacks[i];
        imageStack.visibleImageIndex = stackedCardCell.stackedImageView.visibleImageIndex;
    }
}

#pragma mark - IBActions

- (IBAction)draftButtonTapped
{
    [self.delegate returnToDraftView];
}

- (IBAction)addLandsButtonTapped
{

}

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
    [cell.stackedImageView setImageStack:imageStack];
    [cell.stackedImageView setStackedImageViewDelegate:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRemovingEmptyStack) {
        return;
    }
    
    StackedCardCell *stackedCardCell = (StackedCardCell *)cell;
	
    ImageStack *imageStack = self.imageStacks[indexPath.row];
    imageStack.visibleImageIndex = stackedCardCell.stackedImageView.visibleImageIndex;
}

#pragma mark - configure methods

- (void)configureCards
{
    NSMutableArray *imageStacks = [NSMutableArray new];
    
    for (NSArray *cards in self.deckViewModel.potentialCards) {
        [imageStacks addObject:[[ImageStack alloc] initWithCards:cards]];
    }
    
    self.imageStacks = imageStacks;
    
    [self.collectionView reloadData];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)configureDraftButton
{
    if (self.picks.count >= [[MTGSetService sharedService] boosterPackSize] * 3) {
        self.draftButton.hidden = YES;
    }
}

- (void)configureAddLandsButton
{
    if (self.picks.count < [[MTGSetService sharedService] boosterPackSize] * 3) {
        self.addLandsButton.hidden = YES;
    }
}

#pragma mark - View methods

- (void)dealloc
{
    self.picks = nil;
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
    [self configureDraftButton];
    [self configureAddLandsButton];
}

@end
