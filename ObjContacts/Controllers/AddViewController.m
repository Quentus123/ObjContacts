//
//  AddViewController.m
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddViewController.h"
#import "Card+CoreDataClass.h"
#import "AppDelegate.h"

@implementation AddViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.isImageChanged = false;
    if(_card != nil){
        self.nameTextfield.text = self.card.name;
        self.surnameTextfield.text = self.card.surname;
        self.phoneNumberTextfield.text = self.card.phoneNumber;
        if(self.card.image != nil){
            dispatch_async(dispatch_queue_create("data to image conversion", nil), ^{
                UIImage* imageFromData = [[UIImage alloc] initWithData:self.card.image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.userPhotoImageView.image = imageFromData;
                });
            });
        }
    }
}

- (IBAction)onTapAnnuler:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction) addPhotoFromGalery{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = true;
    [self presentViewController:imagePicker animated:true completion:nil];
}

- (IBAction)onTapOK:(id)sender {
    if(_card != nil){
        self.card.name = self.nameTextfield.text;
        self.card.surname = self.surnameTextfield.text;
        self.card.phoneNumber = self.phoneNumberTextfield.text;
        if(self.userPhotoImageView.image != nil && self.isImageChanged){
            self.card.image = UIImageJPEGRepresentation(self.userPhotoImageView.image, 0.2);
        }
        [((AppDelegate*)UIApplication.sharedApplication.delegate).persistentContainer.viewContext save:nil];
        [self dismissViewControllerAnimated:true completion:^{
            [self.delegate addViewControllerDismissedWithEditedCard:self.card];
        }];
    } else{
        Card* newCard = [[Card alloc] initWithContext:((AppDelegate*)UIApplication.sharedApplication.delegate).persistentContainer.viewContext];
        newCard.name = self.nameTextfield.text;
        newCard.surname = self.surnameTextfield.text;
        newCard.phoneNumber = self.phoneNumberTextfield.text;
        if(self.userPhotoImageView.image != nil){
            newCard.image = UIImageJPEGRepresentation(self.userPhotoImageView.image, 0.2);
        }
        [((AppDelegate*)UIApplication.sharedApplication.delegate).persistentContainer.viewContext save:nil];
        [self dismissViewControllerAnimated:true completion:^{
            [self.delegate addViewControllerDismissedWithAddedCard:newCard];
        }];
        
    }
}

//MARK: UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    self.userPhotoImageView.image = (UIImage*)info[UIImagePickerControllerEditedImage];
    self.isImageChanged = true;
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end
