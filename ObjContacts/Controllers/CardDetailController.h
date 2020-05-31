//
//  CardDetailController.h
//  ObjContacts
//
//  Created by Quentin on 30/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Card+CoreDataClass.h"
#import "CircularButton.h"
#import "CircularImageView.h"
#import "AddViewControllerDelegate.h"
#import "SelectableStackView.h"

@interface CardDetailController : UIViewController <AddViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property Card* card;
@property (weak, nonatomic) IBOutlet CircularImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CircularButton *messageButton;
@property (weak, nonatomic) IBOutlet UILabel *messageButtonLabel;
@property (weak, nonatomic) IBOutlet CircularButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *callButtonLabel;
@property (weak, nonatomic) IBOutlet CircularButton *videoButton;
@property (weak, nonatomic) IBOutlet UILabel *videoButtonLabel;
@property (weak, nonatomic) IBOutlet SelectableStackView *phoneStack;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end
