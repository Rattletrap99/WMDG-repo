//
//  AddCategoryViewController.h
//  WMDGx
//
//  Created by Tim Jones on 3/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDGCategory.h"
#import "WMDGActivity.h"
#import "ReportViewController.h"
#import "ColorPickerView.h"
@class AddActivityViewController;


@protocol AddCategoryViewControllerDelegate <NSObject>

-(void) addCatControllerDidSave;

-(void) addCatControllerDidCancel:(WMDGCategory *) categoryToDelete;

@end

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate>

// ,UICollectionViewDataSource,UICollectionViewDelegate

//@property (strong,nonatomic) ColorPickerView *cpv;



//-(void)setColorChip;

@property (strong, nonatomic) UIColor *colorForColorView;

@property (strong, nonatomic) IBOutlet UITextField *catTextField;

@property (weak, nonatomic) IBOutlet UIView *colorChip;

@property (strong, nonatomic) NSMutableArray *usedColorsArray;

//@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *pickerImageView;

@property (strong,nonatomic) UICollectionViewCell *thisCell;

@property (strong, nonatomic) WMDGCategory *thisCategory;

@property (nonatomic, weak) id <AddCategoryViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;



@end
