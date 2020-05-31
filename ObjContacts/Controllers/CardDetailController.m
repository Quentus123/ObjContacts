//
//  CardDetailController.m
//  ObjContacts
//
//  Created by Quentin on 30/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardDetailController.h"
#import "AddViewController.h"
#import <MessageUI/MessageUI.h>


@implementation CardDetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Modifier" style:UIBarButtonItemStyleDone target:self action:@selector(onTapModifier)];
    
    self.phoneStack.onTap = ^{
        [self onTapCall:nil];
    };
    
    [self updateViews];
}

- (void) updateViews{
    self.nameLabel.text = [[self.card.surname stringByAppendingString:@" "] stringByAppendingString:self.card.name];
    if(self.card.image != nil){
        dispatch_async(dispatch_queue_create("data to image conversion", nil), ^{
            UIImage* imageFromData = [[UIImage alloc] initWithData:self.card.image];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userPhotoImageView.image = imageFromData;
            });
        });
    }
    
    self.phoneNumberLabel.text = self.card.phoneNumber;
    
    UIColor* enabledColor = UIColor.linkColor;
    UIColor* disabledColor = UIColor.darkGrayColor;
    if(self.card.phoneNumber.length == 0){
        
        self.phoneStack.hidden = true;
        self.phoneStack.userInteractionEnabled = false;
        
        self.messageButton.backgroundColor = disabledColor;
        self.messageButtonLabel.textColor = disabledColor;
        
        self.callButton.backgroundColor = disabledColor;
        self.callButtonLabel.textColor = disabledColor;
        
        self.videoButton.backgroundColor = disabledColor;
        self.videoButtonLabel.textColor = disabledColor;
        
    } else {
        
        self.phoneStack.hidden = false;
        self.phoneStack.userInteractionEnabled = true;
        
        self.messageButton.backgroundColor = enabledColor;
        self.messageButtonLabel.textColor = enabledColor;
        
        NSURL* callURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:self.card.phoneNumber]];
        if([UIApplication.sharedApplication canOpenURL:callURL]){
            self.callButton.backgroundColor = enabledColor;
            self.callButtonLabel.textColor = enabledColor;
        } else {
            self.callButton.backgroundColor = disabledColor;
            self.callButtonLabel.textColor = disabledColor;
        }
        
        NSURL* videoCallURL = [NSURL URLWithString:[@"facetime://" stringByAppendingString:self.card.phoneNumber]];
        if([UIApplication.sharedApplication canOpenURL:videoCallURL]){
            self.videoButton.backgroundColor = enabledColor;
            self.videoButtonLabel.textColor = enabledColor;
        } else {
            self.videoButton.backgroundColor = disabledColor;
            self.videoButtonLabel.textColor = disabledColor;
        }
    }
}

- (void) onTapModifier{
    [self performSegueWithIdentifier:@"DetailToAddSegue" sender:self.card];
}

- (IBAction)onTapMessage:(id)sender {
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[self.card.phoneNumber];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:true completion:nil];
    }
}

- (IBAction)onTapCall:(id)sender {
    NSURL* callURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:self.card.phoneNumber]];
    if([UIApplication.sharedApplication canOpenURL:callURL]){
        [UIApplication.sharedApplication openURL:callURL options:@{} completionHandler:nil];
    }
}

- (IBAction)onTapVideoCall:(id)sender {
    NSURL* videoCallURL = [NSURL URLWithString:[@"facetime://" stringByAppendingString:self.card.phoneNumber]];
    if([UIApplication.sharedApplication canOpenURL:videoCallURL]){
        [UIApplication.sharedApplication openURL:videoCallURL options:@{} completionHandler:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isMemberOfClass:AddViewController.class]){
        ((AddViewController *)segue.destinationViewController).card = sender;
        ((AddViewController *)segue.destinationViewController).delegate = self;
        
        [super prepareForSegue:segue sender:sender];
    }
}

//MARK: AddControllerDelegate
- (void)addViewControllerDismissedWithEditedCard:(Card *)card{
    [self updateViews];
}

- (void)addViewControllerDismissedWithAddedCard:(Card *)card{
    @throw [[NSError alloc] init];
}

//MARK: MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:true completion:nil];
}

@end
