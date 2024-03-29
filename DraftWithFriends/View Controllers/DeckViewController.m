//
//  DeckViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 12/19/13.
//  Copyright (c) 2013 Trent Ellingsen. All rights reserved.
//

#import "DeckViewController.h"
#import "StackedCardCell.h"
#import "StackedCardView.h"
#import "DeckViewModel.h"
#import "CardStack.h"
#import "MTGSetService.h"
#import "LandPickerView.h"
#import "UIView+Helpers.h"
#import "DrawViewController.h"
#import "DeckService.h"

NSString * const kStackedCardCellKey = @"stackedCardCell";

@interface DeckViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackedCardViewDelegate, LandPickerViewDelegate>

// Raw data for the deck
@property (nonatomic) DeckViewModel *deckViewModel;

// The way the data needs to be stored for the view
@property (nonatomic) NSArray *cardStacks;

@property (weak, nonatomic) IBOutlet UIButton *draftButton;
@property (weak, nonatomic) IBOutlet UIButton *addLandsButton;
@property (weak, nonatomic) IBOutlet UILabel *creatureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nonCreatureCountLabel;
@property (nonatomic) Card *firstPick;
@property (nonatomic) BOOL isRemovingEmptyStack;

@property (nonatomic) LandPickerView *landPickerView;

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
        self.firstPick = picks.firstObject;
        self.deckViewModel.picks = picks;
    }
}

- (BOOL)isFinishedDrafting
{
    return self.picks.count >= [[MTGSetService sharedService] boosterPackSize] * 3;
}

#pragma mark - LandPickerViewDelegate methods

- (void)donePickingLands
{
    [self.deckViewModel.deckListCards addObjectsFromArray:[self landsForDeck]];
    [self performSegueWithIdentifier:@"showDraw" sender:self];
}

- (NSArray *)landsForDeck
{
    NSMutableArray *lands = [NSMutableArray new];
    
    [lands addObjectsFromArray:[[MTGSetService sharedService] landType:LandSwamp withCount:(int)self.landPickerView.swampStepper.value]];
    [lands addObjectsFromArray:[[MTGSetService sharedService] landType:LandMountain withCount:(int)self.landPickerView.mountainStepper.value]];
    [lands addObjectsFromArray:[[MTGSetService sharedService] landType:LandPlains withCount:(int)self.landPickerView.plainsStepper.value]];
    [lands addObjectsFromArray:[[MTGSetService sharedService] landType:LandIsland withCount:(int)self.landPickerView.islandStepper.value]];
    [lands addObjectsFromArray:[[MTGSetService sharedService] landType:LandForest withCount:(int)self.landPickerView.forestStepper.value]];
    
    return lands;
}

#pragma mark - StackedImageViewDelegate methods

- (void)stackedViewDidEmpty:(CardStack *)cardStack
{
    self.isRemovingEmptyStack = YES;
    
    [self displayHighlightedCards];
    
    NSMutableArray *mutableStacks = [self.cardStacks mutableCopy];
    [mutableStacks removeObject:cardStack];
    self.cardStacks = [mutableStacks copy];
    
    [self.collectionView reloadData];
    self.isRemovingEmptyStack = NO;
}

- (void)didRemoveCard:(Card *)card fromStack:(CardStack *)cardStack
{
    for (NSInteger i = 0; i < self.deckViewModel.deckListCards.count; i++) {
        if (self.deckViewModel.deckListCards[i] == card) {
            [self.deckViewModel.potentialCards addObject:card];
            [self.deckViewModel.deckListCards removeObjectAtIndex:i];
            break;
        }
    }
    
    [self configureStats];
}

- (void)displayHighlightedCards
{
    for (NSInteger i = 0; i < self.cardStacks.count; i++) {
        StackedCardCell *stackedCardCell = (StackedCardCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        CardStack *cardStack = self.cardStacks[i];
        cardStack.highlightedCardIndex = stackedCardCell.stackedCardView.highlightedCardIndex;
    }
}

#pragma mark - IBActions

- (IBAction)draftButtonTapped
{
    if (self.completeDeck) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.delegate returnToDraftView];
    }
}

- (IBAction)addLandsButtonTapped
{
    if (self.completeDeck) {
        [self performSegueWithIdentifier:@"showDraw" sender:nil];
        return;
    }
    
    [self.draftButton removeFromSuperview];
    [self.addLandsButton removeFromSuperview];
    [self.creatureCountLabel removeFromSuperview];
    [self.nonCreatureCountLabel removeFromSuperview];
    
    self.landPickerView = [[[NSBundle mainBundle] loadNibNamed:@"LandPickerViewNib" owner:nil options:nil] lastObject];
    self.landPickerView.delegate = self;
    [self.landPickerView setFrameY:self.view.frame.size.height - self.landPickerView.frame.size.height];
    [self.view addSubview:self.landPickerView];
}

#pragma mark - Collection View methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cardStacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackedCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStackedCardCellKey forIndexPath:indexPath];
	
    CardStack *cardStack = self.cardStacks[indexPath.row];
    [cell.stackedCardView setHighlightedCardIndex:[cardStack highlightedCardIndex]];
    [cell.stackedCardView setCardStack:cardStack];
    [cell.stackedCardView setStackedCardViewDelegate:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRemovingEmptyStack) {
        return;
    }
    
    StackedCardCell *stackedCardCell = (StackedCardCell *)cell;
	
    CardStack *cardStack = self.cardStacks[indexPath.row];
    cardStack.highlightedCardIndex = stackedCardCell.stackedCardView.highlightedCardIndex;
}

#pragma mark - configure methods

- (void)configureCards
{
    if (!self.completeDeck) {
        [self configureCardsView];
        return;
    }
    
    self.deckViewModel.completeDeckCards = self.completeDeck.cards;
    
    [self configureCardsView];
}

- (void)configureCardsView
{
    NSMutableArray *cardStacks = [NSMutableArray new];
    
    for (NSArray *cards in self.deckViewModel.chosenCardStacks) {
        [cardStacks addObject:[[CardStack alloc] initWithCards:cards]];
    }
    
    self.cardStacks = cardStacks;
    
    [self.collectionView reloadData];
    [self configureStats];
}

- (void)configureCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)configureButtons
{
    [self configureDraftButton];
    [self configureAddLandsButton];
}

- (void)configureDraftButton
{
    if (self.completeDeck) {
        [self.draftButton setTitle:@"Decks" forState:UIControlStateNormal];
    } else if ([self isFinishedDrafting]) {
        self.draftButton.hidden = YES;
    }
}

- (void)configureAddLandsButton
{
    if (self.completeDeck) {
        [self.addLandsButton setTitle:@"Test Deck" forState:UIControlStateNormal];
    } else if (![self isFinishedDrafting]) {
        self.addLandsButton.hidden = YES;
    }
}

- (void)configureStatsDisplay
{
    if (self.completeDeck) {
        [self.creatureCountLabel setHidden:YES];
        [self.nonCreatureCountLabel setHidden:YES];
    }
}

- (void)configureStats
{
    NSInteger creatureSpells = 0;
    NSInteger nonCreatureSpells = 0;
    
    for (Card *card in self.deckViewModel.deckListCards) {
        if ([card.types containsObject:@"Creature"]) {
            creatureSpells++;
        } else {
            nonCreatureSpells++;
        }
    }
    
    [self.creatureCountLabel setText:[NSString stringWithFormat:@"Creatures: %ld", (long)creatureSpells]];
    [self.nonCreatureCountLabel setText:[NSString stringWithFormat:@"Non-Creatures: %d", (int)nonCreatureSpells]];
    
    [self.creatureCountLabel setHidden:NO];
    [self.nonCreatureCountLabel setHidden:NO];
}

- (void)configureStyles
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - View methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDraw"]) {
        [segue.destinationViewController setFirstPick:self.firstPick];
        [segue.destinationViewController setCards:self.deckViewModel.deckListCards];
        [segue.destinationViewController setCompleteDeck:self.completeDeck];
    }
}

- (void)dealloc
{
    self.picks = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureStyles];
    [self configureCollectionView];
    [self configureCards];
    [self configureButtons];
    [self configureStatsDisplay];
}

@end
