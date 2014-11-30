//
//  DraftSelectionTableViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 11/29/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "DraftSelectionTableViewController.h"
#import "DraftViewController.h"
#import "DeckService.h"
#import "MTGSetService.h"
#import "MTGSet.h"

NSString * const kDraftSelectionCell = @"kDraftSelectionCell";

@interface DraftSelectionTableViewController () <DraftViewControllerDelegate>

@property (nonatomic) NSArray *draftSelection;
@property (nonatomic) MTGSet *set;

@end

@implementation DraftSelectionTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.draftSelection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDraftSelectionCell forIndexPath:indexPath];
    
    cell.textLabel.text = self.draftSelection[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *setCode = self.draftSelection[indexPath.row][@"setCode"];
    [[MTGSetService sharedService] setWithSetCode:setCode callback:^(NSError *error, MTGSet *set) {
        self.set = set;
        [self performSegueWithIdentifier:@"showDraftPicking" sender:self];
    }];
}

- (NSArray *)draftSelection
{
    if (!_draftSelection) {
        _draftSelection = @[@{@"name":@"KTK x3", @"setCode":@"KTK"}, @{@"name":@"M15 x3", @"setCode":@"M13"}, @{@"name":@"JOU BNG THS", @"setCode":@"THS"}];
    }
    
    return _draftSelection;
}

- (void)displayDeckList
{
    [self performSegueWithIdentifier:@"showDecks" sender:self];
}

#pragma mark - DraftViewControllerDelegate methods

- (void)returnToDraftSelection
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - configure methods

- (void)configureDeckListButton
{
    [[DeckService sharedService] decksWithUserId:nil completed:^(id failureObject, NSArray *decks) {
        if (decks.count == 0) {
            return;
        }
        
        UIBarButtonItem *deckListButton = [[UIBarButtonItem alloc] initWithTitle:@"Decks" style:UIBarButtonItemStyleBordered target:self action:@selector(displayDeckList)];
        self.navigationItem.rightBarButtonItem = deckListButton;
    }];
}

- (void)configureDraftSelectionList
{
    [SVProgressHUD showWithStatus:@"Loading"];
    [[MTGSetService sharedService] draftSelectionList:^(NSError *error, id successObject) {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}

#pragma mark - View Methods

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDraftPicking"]) {
        [(DraftViewController *)segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setCardSet:self.set];
        [segue.destinationViewController setCards:[self.set generateBoosterPack]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self configureDeckListButton];
    [self configureDraftSelectionList];
}

@end
