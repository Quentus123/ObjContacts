//
//  AddViewController.h
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewControllerDelegate.h"
#import "Card+CoreDataClass.h"

@interface AddViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *surnameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) id <AddViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property Boolean isImageChanged;
@property Card* card;

@end
