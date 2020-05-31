//
//  CircularImageView.m
//  ObjContacts
//
//  Created by Quentin on 30/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircularImageView.h"

@implementation CircularImageView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = true;
}

@end
