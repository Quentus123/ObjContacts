//
//  ViewController.h
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewControllerDelegate.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AddViewControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchController* searchController; //lazy prop
@property NSMutableArray* cards;
@property NSMutableDictionary* filteredCards;

@end

