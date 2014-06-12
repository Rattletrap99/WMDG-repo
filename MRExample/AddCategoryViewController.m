//
//  AddCategoryViewController.m
//  WMDGx
//
//  Created by Tim Jones on 3/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "AddCategoryViewController.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

NSMutableArray *array;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.catTextField.delegate = self;
    [self.pickerImageView setUserInteractionEnabled:YES];
    
    // ********************I put this NSLog here to check the status of the property self.colorView
    
    NSLog(@"Color view is %@",self.colorChip);//_colorView	UIView *	0x8a63d30	0x08a63d30
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.catTextField resignFirstResponder];
    return YES;
}


//-(void)setColorChip // ********************This is where the backgroundColor of self.colorView should be set
//{
//    NSLog(@"colorForColorView is %@",self.colorForColorView);
//    NSLog(@"Color chip is %@",self.colorChip); //_colorView	UIView *	nil	0x00000000
//    
//    self.colorChip = [self.view viewWithTag:201];
//    NSLog(@"Color chip is %@",self.colorChip); //_colorView	UIView *	nil	0x00000000
//
//    self.colorChip.layer.cornerRadius = 6;
//
//    [self.colorChip setBackgroundColor:self.colorForColorView];
//    
////    NSLog(@"Color view is %@",self.colorChip); //_colorView	UIView *	nil	0x00000000
//
//    NSLog(@"Color view color is %@",self.colorChip.backgroundColor);
//}

- (IBAction)saveButton:(UIBarButtonItem *)sender
{
    if (self.catTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No category created"
                                                        message:@"Please create a new category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if (!self.colorChip.backgroundColor)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No color selected"
                                                        message:@"Please select a color for your new category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.thisCategory = [WMDGCategory MR_createInContext:localContext];
        self.thisCategory.name = [self.catTextField.text uppercaseString];
        self.thisCategory.color = self.colorChip.backgroundColor;
        [localContext MR_saveToPersistentStoreAndWait];
        [self.thisCell setUserInteractionEnabled:NO];
        [self.delegate addCatControllerDidSave];
    }
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
        [self.delegate addCatControllerDidCancel:self.thisCategory];
    
}

@end

