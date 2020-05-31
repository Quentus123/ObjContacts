//
//  CardCell.m
//  ObjContacts
//
//  Created by Quentin on 29/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardCell.h"

@implementation CardCell

- (HandlerBlock)getOnTapHandler{
    return _onTapHandler;
}

- (void)setOnTapHandler:(__autoreleasing HandlerBlock)handler{
    for (UIGestureRecognizer* gestureRecognizer in self.contentView.gestureRecognizers){
        [self removeGestureRecognizer:gestureRecognizer];
        _onTapHandler = handler;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil){
        [self commonInit];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self != nil){
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil){
        [self commonInit];
    }
    return self;
}

- (void) onTap{
    if(_onTapHandler != nil){
        self.onTapHandler();
    }
}

- (void) commonInit{
    [NSBundle.mainBundle loadNibNamed:@"CardCell" owner:self options:nil];
    [self.contentView addSubview:self.ownerView];
    self.ownerView.frame = self.contentView.bounds;
    self.ownerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self layoutIfNeeded];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

@end
