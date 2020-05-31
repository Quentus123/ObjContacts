//
//  AddViewControllerDelegate.h
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import "Card+CoreDataClass.h"

@protocol AddViewControllerDelegate <NSObject>

- (void) addViewControllerDismissedWithAddedCard: (Card *) card;
- (void) addViewControllerDismissedWithEditedCard: (Card *) card;

@end
