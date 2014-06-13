//
//  AddActivityViewController.m
//  MRExample
//
//  Created by Tim Jones on 11/24/13.
//  Copyright (c) 2013 TDJ. All rights reserved.
//

#import "AddActivityViewController.h"

@interface AddActivityViewController ()
{
    NSFetchedResultsController *catFRC;
}
@end

@implementation AddActivityViewController

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
    [self.pickerView setHidden:YES];
    [self.pickerView setDelegate:self];
    self.activityField.delegate = self;
    
    int currentCategoryCount = [WMDGCategory MR_countOfEntities];
    
    if (currentCategoryCount < 1)
    {
        [self addStarterCategories];
    }
    
    [self.pickerView reloadAllComponents];
    

    NSLog(@"1) Number of WMDGCategory objects is %i", catFRC.fetchedObjects.count); // 1
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.activityField resignFirstResponder];
    
    return YES;
}

-(void) addStarterCategories
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    WMDGCategory *funCategory = [WMDGCategory MR_createInContext:localContext];
    funCategory.name = @"FUN";
    funCategory.color = [UIColor colorWithRed:0.832f green:0.852f blue:0.910f alpha:1.00f];
    
    WMDGCategory *workCategory = [WMDGCategory MR_createInContext:localContext];
    workCategory.name = @"WORK";
    workCategory.color = [UIColor colorWithRed:0.910f green:0.804f blue:0.817f alpha:1.00f];
    
    [localContext MR_saveToPersistentStoreAndWait];
}

#pragma mark Picker View datasource

// returns the number of 'columns' to display

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    catFRC = [WMDGCategory MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"name" ascending:YES];
    NSLog(@"2) Number of WMDGCategory objects is %i", catFRC.fetchedObjects.count); // 2
    return catFRC.fetchedObjects.count;
}

#pragma mark Picker View delegate


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString * titleName;
    titleName = [[catFRC.fetchedObjects objectAtIndex:row]name];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:titleName attributes:@{NSForegroundColorAttributeName:[[catFRC.fetchedObjects objectAtIndex:row]color]}];
    
    return attString;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.thisCategory = [catFRC.fetchedObjects objectAtIndex:row];
    self.categoryLabel.text = self.thisCategory.name;
    self.categoryLabel.textColor = self.thisCategory.color;
//    [self.pickerView setHidden:YES];

}


#pragma mark Buttons

- (IBAction)selectCategoryButton:(UIButton *)sender
{
    int catCount = [WMDGCategory MR_countOfEntities];

    if (catCount > 0)
    {
        NSFetchedResultsController *pickerFRC = [[NSFetchedResultsController alloc]init];
        
        pickerFRC = [WMDGCategory MR_fetchAllSortedBy:@"name"
                                         ascending:YES withPredicate:nil
                                           groupBy:nil
                                          delegate:nil];
        
        if([self.activityField isFirstResponder])
        {
            [self.activityField resignFirstResponder];
        }

        [self.pickerView setHidden:NO];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
//        catFRC = [WMDGCategory MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"name" ascending:YES];

        [self.pickerView reloadAllComponents];
    }
    
    else
    {
        // Alert
        NSString * titleString = [[NSString alloc] initWithFormat:@"No categories created yet"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:@"Please press New Category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark Cancel and Save Buttons

- (IBAction)saveButton:(UIBarButtonItem *)sender
{
    if (self.activityField.text.length > 0)
    {
        if (self.categoryLabel.text.length < 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No category selected"
                                                            message:@"Please select a category or Cancel"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        else
        {
//            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//            self.thisActivity = [WMDGActivity MR_createInContext:localContext];
            self.thisActivity.name = self.activityField.text;
            self.thisActivity.category = self.thisCategory.name;
//            [localContext MR_saveToPersistentStoreAndWait];
            
            NSLog(@"Category name is %@", self.thisCategory.name);
            NSLog(@"Activity name is %@", self.thisActivity.name);
            [self.delegate addActivityViewControllerDidSave];
        }
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No activity entered"
                                                        message:@"Please enter a new activity or Cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{    
    [self.delegate addActivityViewControllerDidCancel:self.thisActivity];
//    NSLog(@"delegate is %@",self.delegate);

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    AddCategoryViewController *acvc = (AddCategoryViewController *)navController.topViewController;
    acvc.delegate = self;
    [self.pickerView setHidden:YES];
}


#pragma mark - AddCatControllerDelegate stuff

-(void) addCatControllerDidSave
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    int catCount = [WMDGCategory MR_countOfEntities];
    NSLog(@"3) Number of WMDGCategory objects in store is %d", catCount);
    
    [self.pickerView reloadAllComponents];
    
}

-(void) addCatControllerDidCancel:(WMDGCategory *) categoryToDelete
{
    if (categoryToDelete)
    {
        [categoryToDelete MR_deleteEntity];
    }
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self refreshData];
    
}


@end
