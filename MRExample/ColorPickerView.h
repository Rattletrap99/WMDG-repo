//
//  ColorPickerView.h
//  WMDGx
//
//  Created by Tim Jones on 6/10/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIView_ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>
#import "AddCategoryViewController.h"


@interface ColorPickerView : UIImageView

@property (strong,nonatomic) UIColor *pickedColor;
@property (strong,nonatomic) UIView *colorChip;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

//@property (strong,nonatomic) AddCategoryViewController *addCatVC;


@end
