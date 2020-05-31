//
//  SelectableStackView.m
//  ObjContacts
//
//  Created by Quentin on 31/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectableStackView.h"

@implementation SelectableStackView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    
    if(self != nil){
        UIView* strongBackgroundView = [[UIView alloc] init];
        [self insertSubview:strongBackgroundView atIndex:0];
        self.backgroundView = strongBackgroundView;
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false;
        [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
        [self.backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
        [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
        [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)]];
    }
    
    return self;
}

- (void) tapDetected{
    if(_onTap != nil){
        self.onTap();
    }
    
    self.backgroundView.backgroundColor = UIColor.clearColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    self.backgroundView.backgroundColor = UIColor.systemGray5Color;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    self.backgroundView.backgroundColor = UIColor.clearColor;
}

@end
