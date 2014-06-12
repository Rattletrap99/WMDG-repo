//
//  AddActivityViewController.h
//  MRExample
//
//  Created by Tim Jones on 11/24/13.
//  Copyright (c) 2013 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDGActivity.h"
#import "WMDGCategory.h"
#import "AddCategoryViewController.h"
@class HomeViewController;


@protocol AddActivityViewControllerDelegate <NSObject>

-(void) addActivityViewControllerDidSave;

-(void) addActivityViewControllerDidCancel:(WMDGActivity *) activityToDelete;

@end


@interface AddActivityViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,AddCategoryViewControllerDelegate>

@property (strong, nonatomic) WMDGActivity *thisActivity;
@property (strong, nonatomic) WMDGCategory *thisCategory;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *activityField;

@property (nonatomic, weak) id <AddActivityViewControllerDelegate> delegate;


- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

