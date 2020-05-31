//
//  SelectableStackView.h
//  ObjContacts
//
//  Created by Quentin on 31/05/2020.
//  Copyright © 2020 Quentin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectableStackView : UIStackView

typedef void (^TapHandler) (void);

@property (weak, nonatomic) UIView* backgroundView;
@property TapHandler onTap;

@end
