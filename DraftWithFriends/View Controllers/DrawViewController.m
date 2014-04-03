//
//  DrawViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DrawViewController.h"
#import "StackedCardCell.h"
#import "ImageStack.h"
#import "DrawViewModel.h"
#import "DeckService.h"
#import "UserService.h"

NSString * const kStackedDrawCardCellKey = @"stackedCardCell";

@interface DrawViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackedImageViewDelegate>

// The way the data needs to be stored for the view
@property (nonatomic) NSArray *imageStacks;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic) DrawViewModel *drawViewModel;
@property (nonatomic) BOOL isRemovingEmptyStack;

@property (nonatomic) ImageStack *drawImageStack;
@property (nonatomic) ImageStack *playedImageStack;

@end

@implementation DrawViewController

- (DrawViewModel *)drawViewModel
{
    if (!_drawViewModel) {
        _drawViewModel = [DrawViewModel new];
    }
    
    return _drawViewModel;
}

- (void)reloadCards
{
    self.imageStacks = [NSArray new];
    if (!self.drawImageStack) {
        self.drawImageStack = [[ImageStack alloc] initWithCards:self.drawViewModel.cardsDrawn];
    } else {
        [self.drawImageStack setCards:self.drawViewModel.cardsDrawn];
    }
    if (!self.playedImageStack) {
        self.playedImageStack = [[ImageStack alloc] initWithCards:self.drawViewModel.cardsPlayed];
    } else {
        [self.playedImageStack setCards:self.drawViewModel.cardsPlayed];
    }
    
    if (self.drawImageStack.cards.count > 0) {
        self.imageStacks = @[self.drawImageStack];
    }
    if (self.playedImageStack.cards.count > 0) {
        self.imageStacks = [self.imageStacks arrayByAddingObject:self.playedImageStack];
    }
    
    [self setVisibleImages];
    [self.collectionView reloadData];
}

- (void)showShareDeck
{
    if (self.completeDeck) {
        [[DeckService sharedService] shareDeck:self.completeDeck withUserEmail:@"jnnmark@gmail.com"];
    }
}

#pragma mark - IBActions

- (IBAction)drawTapped
{
    [self.drawViewModel drawCard];
    
    [self reloadCards];
}

- (IBAction)newDraftTapped
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)redrawTapped
{
    [self configureCards];
}

- (IBAction)refreshTapped
{
    [self reloadCards];
}

- (IBAction)shareTapped
{
    [self showShareDeck];
}

#pragma mark - StackedImageViewDelegate methods

- (void)didRemoveCard:(Card *)card fromStack:(ImageStack *)imageStack
{
    if (imageStack == self.drawImageStack) {
        for (NSInteger i = 0; i < self.drawViewModel.cardsDrawn.count; i++) {
            if (self.drawViewModel.cardsDrawn[i] == card) {
                [self.drawViewModel.cardsPlayed addObject:card];
                [self.drawViewModel.cardsDrawn removeObjectAtIndex:i];
                break;
            }
        }
    } else {
        for (NSInteger i = 0; i < self.drawViewModel.cardsPlayed.count; i++) {
            if (self.drawViewModel.cardsPlayed[i] == card) {
                [self.drawViewModel.cardsPlayed removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    [self reloadCards];
}

- (void)stackedViewDidEmpty
{
    self.isRemovingEmptyStack = YES;
    
    [self setVisibleImages];
    [self reloadCards];
    
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

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageStacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStackedDrawCardCellKey forIndexPath:indexPath];
	
    ImageStack *imageStack = self.imageStacks[indexPath.row];
    [cell.stackedImageView setVisibleImageIndex:[imageStack visibleImageIndex]];
    [cell.stackedImageView setImageStack:imageStack];
    [cell.stackedImageView setStackedImageViewDelegate:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRemovingEmptyStack || indexPath.row >= self.imageStacks.count) {
        return;
    }
    
    StackedCardCell *stackedCardCell = (StackedCardCell *)cell;
	
    ImageStack *imageStack = self.imageStacks[indexPath.row];
    imageStack.visibleImageIndex = stackedCardCell.stackedImageView.visibleImageIndex;
}


#pragma mark - configure methods

- (void)configureShareButton
{
    if (!self.completeDeck) {
        self.shareButton.hidden = YES;
    }
}

- (void)configureCards
{
    self.drawViewModel.cardsInLibrary = [self.cards mutableCopy];
    self.drawViewModel.cardsDrawn = [NSMutableArray new];
    self.drawViewModel.cardsPlayed = [NSMutableArray new];
    [self.drawViewModel drawHand];
    
    [self reloadCards];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark - view methods

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.completeDeck) {
        return;
    }
    
    CompleteDeck *deck = [[CompleteDeck alloc] initWithCards:self.cards
                                                featuredCard:self.firstPick
                                                      userId:[[UserService sharedService] currentUser].userId
                                                 dateDrafted:[NSDate date]];
    
    [[DeckService sharedService] saveDeck:deck];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureCards];
}


@end
