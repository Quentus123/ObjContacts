//
//  CardCell.h
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell

typedef void (^HandlerBlock)(void);


@property (strong, nonatomic) IBOutlet UIView *ownerView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) HandlerBlock onTapHandler;

- (void) setOnTapHandler: (HandlerBlock) handler;
- (HandlerBlock) getOnTapHandler;

@end
