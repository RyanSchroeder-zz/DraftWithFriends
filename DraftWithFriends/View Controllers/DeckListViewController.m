
//
//  DeckListViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DeckListViewController.h"
#import "Consts.h"
#import "ListedDeckCell.h"
#import "UserService.h"
#import "DeckService.h"
#import "CompleteDeck.h"
#import "DeckViewController.h"

@interface DeckListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *decks;
@property (nonatomic) CompleteDeck *selectedDeck;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation DeckListViewController

#pragma mark - IBActions

- (IBAction)editTapped:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                style:UIBarButtonItemStyleDone
                                                                               target:self 
                                                                               action:@selector(doneTapped:)] animated:YES];
}

- (void)doneTapped:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(editTapped:)] animated:YES];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompleteDeck *deckToDelete = self.decks[indexPath.row];
    [self.decks removeObject:deckToDelete];
    
    [[DeckService sharedService] deleteDeck:deckToDelete];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.decks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListedDeckCell *cell = [tableView dequeueReusableCellWithIdentifier:kListedDeckCell forIndexPath:indexPath];
    CompleteDeck *deck = self.decks[indexPath.row];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a, MMM dd, YYYY"];
    cell.dateLabel.text = [dateFormatter stringFromDate:deck.dateDrafted];
    cell.averageCMCLabel.text = [NSString stringWithFormat:@"Average CMC: %.2f", [deck.averageCMC floatValue]];
    cell.colorsLabel.text = [self deckColors_:deck.colors];
    [cell.cardImageView setImageWithURL:deck.featuredCard.smallImageURL placeholderImage:nil];
    
    if (![deck.userId isEqualToString:[[UserService sharedService] currentUser].userId]) {
        [cell.draftedByLabel setHidden:NO];
        [cell.draftedByLabel setText:[NSString stringWithFormat:@"Drafted By: Mock"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDeck = self.decks[indexPath.row];
    [self performSegueWithIdentifier:@"showDeck" sender:nil];
}

#pragma mark - private methods

- (NSString *)deckColors_:(NSArray *)colors
{
    NSString *colorsString = @"";
    
    for (NSString *color in colors) {
        colorsString = [colorsString stringByAppendingString:[NSString stringWithFormat:@"%@, ", color]];
    }
    
    colorsString = [colorsString substringToIndex:colorsString.length - 2];
    
    return colorsString;
}

#pragma mark - Configure methods

- (void)configureDeckList
{
    NSLog(@"Loading...");
 
    NSString *userId = [[UserService sharedService] currentUser].userId;
    [[DeckService sharedService] decksWithUserId:userId completed:^(id failureObject, NSArray *decks) {
        self.decks = [decks mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)configureSharedDeckList
{
    NSLog(@"Loading Shared...");
    
    NSString *userId = [[UserService sharedService] currentUser].userId;
    [[DeckService sharedService] decksSharedWithUserId:userId completed:^(id failureObject, NSArray *decks) {
        self.decks = [decks mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)configureList
{
    if (self.isSharedDeckList) {
        [self configureSharedDeckList];
    } else {
        [self configureDeckList];
    }
}

- (void)configureButtons
{
    if (self.isSharedDeckList) {
        [self.navigationItem setRightBarButtonItem:nil];
    }
}

- (void)configureStyles
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configureTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - View methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDeck"]) {
        [segue.destinationViewController setCompleteDeck:self.selectedDeck];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configureStyles];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureButtons];
    [self configureList];
    [self configureTableView];
}

@end
