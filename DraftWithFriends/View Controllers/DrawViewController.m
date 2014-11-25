//
//  DrawViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/8/14.
//  Copyright (c) 2014 Trent Ellingsen. All rights reserved.
//

#import "DrawViewController.h"
#import "StackedCardCell.h"
#import "CardStack.h"
#import "DrawViewModel.h"
#import "DeckService.h"
#import "UserService.h"
#import "ShareDeckView.h"
#import "UIView+Helpers.h"

NSString * const kStackedDrawCardCellKey = @"stackedCardCell";

@interface DrawViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackedCardViewDelegate, ShareDeckViewDelegate>

// The way the data needs to be stored for the view
@property (nonatomic) NSArray *cardStacks;

@property (nonatomic) DrawViewModel *drawViewModel;
@property (nonatomic) BOOL isRemovingEmptyStack;

@property (nonatomic) CardStack *drawCardStack;
@property (nonatomic) CardStack *playedCardStack;
@property (nonatomic) ShareDeckView *shareDeckView;

@property (nonatomic) UIView *overlay;

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
    self.cardStacks = [NSArray new];
    if (!self.drawCardStack) {
        self.drawCardStack = [[CardStack alloc] initWithCards:self.drawViewModel.cardsDrawn];
    } else {
        [self.drawCardStack setCards:self.drawViewModel.cardsDrawn];
    }
    if (!self.playedCardStack) {
        self.playedCardStack = [[CardStack alloc] initWithCards:self.drawViewModel.cardsPlayed];
    } else {
        [self.playedCardStack setCards:self.drawViewModel.cardsPlayed];
    }
    
    if (self.drawCardStack.cards.count > 0) {
        self.cardStacks = @[self.drawCardStack];
    }
    if (self.playedCardStack.cards.count > 0) {
        self.cardStacks = [self.cardStacks arrayByAddingObject:self.playedCardStack];
    }
    
    [self setVisibleImages];
    [self.collectionView reloadData];
}

- (void)showShareDeck
{
    [self showOverlay];
    
    self.shareDeckView = [ShareDeckView new];
    self.shareDeckView.delegate = self;
    [self.shareDeckView setFrameY:-self.shareDeckView.frameHeight];
    [self.view addSubview:self.shareDeckView];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shareDeckView.center = CGPointMake(self.view.center.x, self.view.center.y / 2);
        [self.overlay setAlpha:0.5];
    } completion:nil];
    
    [self.shareDeckView.emailTextField becomeFirstResponder];
}

- (void)showOverlay
{
    [self setOverlay:[[UIView alloc] initWithFrame:self.view.frame]];
    [self.overlay setBackgroundColor:[UIColor blackColor]];
    [self.overlay setAlpha:0.0];
    [self.view addSubview:self.overlay];
    
    [self.overlay addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShareView)]];
}

- (void)dismissShareView
{
    [self.shareDeckView.emailTextField endEditing:YES];
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.shareDeckView setFrameY:-self.shareDeckView.frameHeight];
        [self.overlay setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.shareDeckView removeFromSuperview];
        [self.overlay removeFromSuperview];
    }];
}

#pragma mark - ShareViewDelegate methods

/**
 Delegate method for the share view
 */
- (void)didTapShare
{
    [[DeckService sharedService] shareDeck:self.completeDeck withUserEmail:self.shareDeckView.emailTextField.text completed:^(id failureObject, id object) {
        if (!failureObject) {
            [self dismissShareView];
        } else {
            NSLog(@"%@", failureObject);
        }
    }];
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

#pragma mark - StackedImageViewDelegate methods

- (void)didRemoveCard:(Card *)card fromStack:(CardStack *)imageStack
{
    if (imageStack == self.drawCardStack) {
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

- (void)stackedViewDidEmpty:(CardStack *)cardStack
{
    self.isRemovingEmptyStack = YES;
    
    [self setVisibleImages];
    [self reloadCards];
    
    self.isRemovingEmptyStack = NO;
}

- (void)setVisibleImages
{
    for (NSInteger i = 0; i < self.cardStacks.count; i++) {
        StackedCardCell *stackedCardCell = (StackedCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        CardStack *cardStack = self.cardStacks[i];
        cardStack.highlightedCardIndex = stackedCardCell.stackedCardView.highlightedCardIndex;
    }
}

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardStacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStackedDrawCardCellKey forIndexPath:indexPath];
	
    CardStack *cardStack = self.cardStacks[indexPath.row];
    [cell.stackedCardView setHighlightedCardIndex:[cardStack highlightedCardIndex]];
    [cell.stackedCardView setCardStack:cardStack];
    [cell.stackedCardView setStackedCardViewDelegate:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRemovingEmptyStack || indexPath.row >= self.cardStacks.count) {
        return;
    }
    
    StackedCardCell *stackedCardCell = (StackedCardCell *)cell;
	
    CardStack *cardStack = self.cardStacks[indexPath.row];
    cardStack.highlightedCardIndex = stackedCardCell.stackedCardView.highlightedCardIndex;
}


#pragma mark - configure methods

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
    
    CompleteDeck *deck = [CompleteDeck new];
    deck.cards = self.cards;
    deck.featuredCard = self.firstPick;
    deck.userId = [[UserService sharedService] currentUser].userId;
    deck.dateDrafted = [NSDate date];
    deck.draftedBy = [[UserService sharedService] currentUser].name;
    
    [[DeckService sharedService] saveDeck:deck];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureCards];
}


@end
