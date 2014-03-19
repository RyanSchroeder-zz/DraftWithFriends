
//
//  DeckListViewController.m
//  DraftWithFriends
//
//  Created by Trent Ellingsen on 3/18/14.
//  Copyright (c) 2014 Ryan Schroeder. All rights reserved.
//

#import "DeckListViewController.h"
#import "Consts.h"
#import "ListedDeckCell.h"
#import "UserService.h"
#import "DeckService.h"
#import "CompleteDeck.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DeckListViewController ()

@property (nonatomic) NSArray *decks;
@property (nonatomic) CompleteDeck *selectedDeck;

@end

@implementation DeckListViewController


#pragma mark - Table view data source

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
    [dateFormatter setDateFormat:@"hh:mm a"];
    cell.timeLabel.text = [dateFormatter stringFromDate:deck.dateDrafted];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    cell.dateLabel.text = [dateFormatter stringFromDate:deck.dateDrafted];
    
    cell.colorsLabel.text = [deck.colors description];
    [cell.imageView setImageWithURL:deck.featuredCard.smallImageURL placeholderImage:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedDeck = self.decks[indexPath.row];
    NSLog(@"%@", self.selectedDeck.featuredCard);
}

#pragma mark - Configure methods

- (void)configureDeckList
{
    NSString *userId = [[UserService sharedService] currentUser].userId;
    [[DeckService sharedService] decksWithUserId:userId completed:^(id failureObject, NSArray *decks) {
        self.decks = decks;
        [self.tableView reloadData];
    }];
}

- (void)configureStyles
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureStyles];
    [self configureDeckList];
}

@end
