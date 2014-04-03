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
#import "LandPickerView.h"
#import "UIView+Helpers.h"
#import "DrawViewController.h"
#import "DeckService.h"

NSString * const kStackedCardCellKey = @"stackedCardCell";

@interface DeckViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackedImageViewDelegate, LandPickerViewDelegate>

// Raw data for the deck
@property (nonatomic) DeckViewModel *deckViewModel;

// The way the data needs to be stored for the view
@property (nonatomic) NSArray *imageStacks;

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

- (void)setCompleteDeck:(CompleteDeck *)completeDeck
{
    if (_completeDeck != completeDeck) {
        _completeDeck = completeDeck;
        self.deckViewModel.completeDeckCards = completeDeck.cards;
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

- (void)didRemoveCard:(Card *)card fromStack:(ImageStack *)imageStack
{
    if (imageStack.cards.count == 0) {
        self.isRemovingEmptyStack = YES;
        
        [self setVisibleImages];
        
        NSMutableArray *mutableStacks = [self.imageStacks mutableCopy];
        [mutableStacks removeObject:imageStack];
        self.imageStacks = [mutableStacks copy];
        
        [self.collectionView reloadData];
        self.isRemovingEmptyStack = NO;
    }
    for (NSInteger i = 0; i < self.deckViewModel.deckListCards.count; i++) {
        if (self.deckViewModel.deckListCards[i] == card) {
            [self.deckViewModel.potentialCards addObject:card];
            [self.deckViewModel.deckListCards removeObjectAtIndex:i];
            break;
        }
    }
    
    [self configureStats];
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
    if (self.completeDeck) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.delegate returnToDraftView];
    }
}

- (IBAction)refreshViewTapped
{
    [self.collectionView reloadData];
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
    
    for (NSArray *cards in self.deckViewModel.chosenCardStacks) {
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
    
    [self.creatureCountLabel setText:[NSString stringWithFormat:@"Creatures: %d", creatureSpells]];
    [self.nonCreatureCountLabel setText:[NSString stringWithFormat:@"Non-Creatures: %d", nonCreatureSpells]];
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
    [self configureStats];
}

@end
