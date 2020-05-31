//
//  ViewController.m
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AddViewController.h"
#import "Card+CoreDataClass.h"
#import "CardCell.h"
#import "CardDetailController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.prefersLargeTitles = true;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationItem.title = @"Contacts";
    
    UISearchController* searchController = [self searchController];
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchController.obscuresBackgroundDuringPresentation = false;
    searchController.definesPresentationContext = true;
    searchController.searchBar.delegate = self;
    self.navigationItem.searchController = [self searchController];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onTapAddButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CardCell class] forCellReuseIdentifier:@"CardCell"];
    
    [self refreshCards];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UISearchController *)searchController {
    if(_searchController == nil){
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    }
    
    return _searchController;
}

- (void) onTapAddButton{
    [self performSegueWithIdentifier:@"MainToAddSegue" sender:nil];
}

- (void) openAddControllerWithCard: (nullable Card*) card{
    [self performSegueWithIdentifier:@"MainToDetailSegue" sender:card];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isMemberOfClass:AddViewController.class]){
        ((AddViewController *)segue.destinationViewController).card = sender;
        ((AddViewController *)segue.destinationViewController).delegate = self;
    } else if ([segue.destinationViewController isMemberOfClass:CardDetailController.class]) {
        ((CardDetailController *)segue.destinationViewController).card = sender;
    }
    
    
    [super prepareForSegue:segue sender:sender];
}

- (void) refreshCards {
    //get cards from core data
    NSFetchRequest* cardsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    self.cards = [[((AppDelegate*)UIApplication.sharedApplication.delegate).persistentContainer.viewContext executeFetchRequest:cardsRequest error:nil] mutableCopy];
    
    //now filter, group and sort them
    NSString* searchText = self.searchController.searchBar.text;
    
    NSMutableArray* filteredCards;
    if([searchText stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceAndNewlineCharacterSet].length == 0) {
        filteredCards = [self.cards mutableCopy];
    } else {
        filteredCards = [[self.cards filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [[evaluatedObject surname].lowercaseString hasPrefix:searchText.lowercaseString];
        }]] mutableCopy];
        [filteredCards sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [((Card*)obj1).surname compare:((Card*)obj2).surname] == NSOrderedDescending;
        }];
    }
    
    NSMutableDictionary* groupedCards = [NSMutableDictionary new];
    for (Card* card in filteredCards){
        if(card.surname.length > 0){
            unichar firstLetter = [card.surname characterAtIndex:0];
            NSString* firstLetterString = [NSString stringWithCharacters:&firstLetter length:1];
            if([groupedCards objectForKey:firstLetterString]){
                [((NSMutableArray*) groupedCards[firstLetterString]) addObject:card];
            } else {
                NSMutableArray* newLettersArray = [[NSMutableArray alloc] initWithObjects:card, nil];
                groupedCards[firstLetterString] = newLettersArray;
            }
        }
    }
    
    self.filteredCards = groupedCards;
}

//MARK: UITableViewDataSource
//Next func is helper
- (NSString*)getLetterForSection: (NSInteger) section{
    NSArray* sortedFilteredCards = [self.filteredCards keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* surname1 = ((Card*)((NSArray*)obj1)[0]).surname;
        NSString* surname2 = ((Card*)((NSArray*)obj2)[0]).surname;
        return [surname1 compare:surname2] == NSOrderedDescending;
    }];
    return sortedFilteredCards[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.filteredCards.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* letterForSection = [self getLetterForSection:section];
    return ((NSArray*)self.filteredCards[letterForSection]).count;
}

//MARK: UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* letterForSection = [self getLetterForSection:indexPath.section];
    Card* item = [((NSArray*)self.filteredCards[letterForSection]) objectAtIndex:indexPath.row];
    CardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[CardCell alloc]  initWithFrame:CGRectZero];
    }
    
    cell.onTapHandler = ^{
        [self openAddControllerWithCard:item];
    };
    
    cell.label.text = item.surname;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self getLetterForSection:section].uppercaseString;
}

//MARK: UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self refreshCards];
    [self.tableView reloadData];
}

//MARK: AddViewControllerDelegate
-(void)addViewControllerDismissedWithAddedCard:(Card *)card{
    [self refreshCards];
    [self.tableView reloadData];
}

- (void)addViewControllerDismissedWithEditedCard:(Card *)card{
    [self.tableView reloadData];
}


@end
