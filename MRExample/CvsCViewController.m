//
//  CvsCViewController.m
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "CvsCViewController.h"

@interface CvsCViewController ()

{
    NSFetchedResultsController *frc;
}

@end

@implementation CvsCViewController

NSIndexPath *thisIndexPath;
UITableViewCell *selectedCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *setButton = (UIButton *)[self.view viewWithTag:103];
    setButton.userInteractionEnabled = NO;
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    clearButton.userInteractionEnabled = NO;
    
    for (NSInteger j = 0; j < [self.myTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.myTableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell * cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [self.timeFrameLabel setHidden:YES];
    [self.timeFrameButton setHidden:YES];
    
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    doneButton.enabled = NO;
    
    [self.timeFrameButton setSelectedSegmentIndex:-1];
    
    [self refreshData];
    [self.myTableView setHidden:NO];
    [self.mainSelectLabel setText:@"Select first category"];
    self.firstCategoryLabel.textColor = [UIColor blackColor];
    self.secondCategorylabel.textColor = [UIColor blackColor];
    self.timeFrameLabel.textColor = [UIColor blackColor];
//    [self.mainSelectLabel setHidden:NO];
//    [self.timeFrameLabel setHidden:YES];
}

#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WMDGCategory *thisCategory = [frc objectAtIndexPath:indexPath];
    cell.textLabel.text = thisCategory.name;
    cell.backgroundColor = thisCategory.color;
    NSAttributedString *attString;
    attString = cell.textLabel.attributedText;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:22];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cVScCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor blackColor];
    [cell.textLabel.text uppercaseString];
    NSAttributedString *attString;
    attString = cell.textLabel.attributedText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIButton *setButton = (UIButton *)[self.view viewWithTag:103];
    setButton.userInteractionEnabled = YES;
    
    
    NSIndexPath *thisIndexPath = indexPath;
    NSString * alertString = [[NSString alloc] initWithFormat:@"%@ already selected",self.firstCategoryLabel.text ];

    
    if (self.lastIndexPath)
    {
        UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedCell = [tableView cellForRowAtIndexPath:thisIndexPath];
        
        NSLog(@"lastIndexPath is %@", self.lastIndexPath);
        
        // *******************************Alert if this is a duplicate selection******************************

        if (lastSelectedCell.textLabel.text == selectedCell.textLabel.text)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString
                                                            message:@"Please select different category or Cancel"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }

    }
    NSLog(@"indexPath is %@", indexPath);
    
    selectedCell = [tableView cellForRowAtIndexPath:thisIndexPath];
    //    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:self.lastIndexPath animated:NO];
    
    self.lastIndexPath = thisIndexPath;
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    clearButton.userInteractionEnabled = YES;
    
}




-(void) refreshData
{

    frc = [WMDGCategory MR_fetchAllSortedBy:@"name"
                                  ascending:YES
                              withPredicate:nil
                                    groupBy:nil
                                   delegate:nil];

    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Buttons


- (IBAction)clearButton:(UIButton *)sender
{
    [self clearEverything];
}

- (IBAction)timeFrameSelector:(UISegmentedControl *)sender
{
    self.currentSpec.toDate = [NSDate date];
    
    switch ([sender selectedSegmentIndex])
    {
        case 0:
            self.currentSpec.fromDate = [self.currentSpec.toDate dateByAddingTimeInterval: -86400];
            self.timeFrameLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.timeFrameLabel.text = @"1 day";
            break;
        case 1:
            self.currentSpec.fromDate = [self.currentSpec.toDate dateByAddingTimeInterval: -604800];
            self.timeFrameLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.timeFrameLabel.text = @"7 days";
            break;
        case 2:
            self.currentSpec.fromDate = [self.currentSpec.toDate dateByAddingTimeInterval: -2419200];
            self.timeFrameLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.timeFrameLabel.text = @"28 days";
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    doneButton.enabled = YES;
    
}

- (IBAction)setButton:(UIButton *)sender
{
    UIButton *setButton = (UIButton *)[self.view viewWithTag:103];
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    clearButton.userInteractionEnabled = YES;
    
//    NSLog(@"FirstActivity Label is %@",self.firstActivityLabel.text);
//    NSLog(@"selectedCell.textLabel.text is %@",selectedCell.textLabel.text);
    
    
    
    for (NSInteger j = 0; j < [self.myTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.myTableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell * cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.myTableView deselectRowAtIndexPath:self.lastIndexPath animated:NO];
        }
    }
    
    
    
    if ([self.secondCategorylabel.text isEqualToString: @"2nd"])
    {
        [self.myTableView setHidden:NO];
        thisIndexPath = self.lastIndexPath;
        selectedCell = [self.myTableView cellForRowAtIndexPath:thisIndexPath];
        //        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.myTableView deselectRowAtIndexPath:thisIndexPath animated:NO];
    }
    
    
    
    else
    {
        nil;
    }
    
    
    
    //    UIButton *selectButton = (UIButton *)[self.view viewWithTag:101];
    //    UIButton *setButton = (UIButton *)[self.view viewWithTag:103];
    
    if (selectedCell != nil)
    {
        
        if ([self.mainSelectLabel.text isEqual: @"Select first category"])
        {
            self.firstCategoryLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.firstCategoryLabel.text = selectedCell.textLabel.text;
            [self.mainSelectLabel setText:@"Select second category"];
        }
        else if ([self.mainSelectLabel.text isEqual: @"Select second category"])
        {
            self.secondCategorylabel.textColor = Rgb2UIColor(183, 2, 0);
            self.secondCategorylabel.text = selectedCell.textLabel.text;
            [self.mainSelectLabel setText:@"Select timeframe"];
            
            [self.timeFrameLabel setHidden:NO];
            
            [self.timeFrameButton setHidden:NO];
            self.myTableView.userInteractionEnabled = NO;

            
        }
        //
        //        else if ([self.mainSelectLabel.text isEqualToString:@"Select timeframe"])
        //        {
        ////            self.timeFrameLabel.text =
        //        }
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No activity selected"
                                                        message:@"Please select an activity or Cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    //        [self.myTableView setHidden:YES];
    
    setButton.userInteractionEnabled = NO;
}


- (IBAction)doneButton:(UIBarButtonItem *)sender
{
    if (self.currentSpec.fromDate)
    {
        // Assign activityOfInterest and benchmarkActivity
        // fromDate and toDate already assigned in timeFrameSelector if a time frame has been selected
        
        self.currentSpec.categoryOfInterest = self.firstCategoryLabel.text;
        self.currentSpec.benchmarkCategory = self.secondCategorylabel.text;
    }
    [self checkForInstances];
}




- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
    [self.delegate CvsCViewControllerDidCancel:self.currentSpec];

}


-(void) checkForInstances
{
    NSPredicate *cOiCountFinderPredicate = [NSPredicate predicateWithFormat:@"category == %@ AND ((startTime >= %@ AND stopTime <= %@) OR (startTime <= %@ AND stopTime >= %@) OR (startTime >= %@ AND stopTime == NULL))",self.currentSpec.categoryOfInterest,self.currentSpec.fromDate,self.currentSpec.toDate,self.currentSpec.fromDate,self.currentSpec.fromDate,self.currentSpec.fromDate];
    
    NSPredicate *bmcCountFinderPredicate = [NSPredicate predicateWithFormat:@"category == %@ AND ((startTime >= %@ AND stopTime <= %@) OR (startTime <= %@ AND stopTime >= %@) OR (startTime >= %@ AND stopTime == NULL))",self.currentSpec.categoryOfInterest,self.currentSpec.fromDate,self.currentSpec.toDate,self.currentSpec.fromDate,self.currentSpec.fromDate,self.currentSpec.fromDate];
    
    int cOiCount = 0;
    int bmcCount = 0;
    
    cOiCount = [TimedActivity MR_countOfEntitiesWithPredicate:cOiCountFinderPredicate];

    bmcCount = [TimedActivity MR_countOfEntitiesWithPredicate:bmcCountFinderPredicate];
    
    NSLog(@"Timeframe fromDate is %@",self.currentSpec.fromDate);
    NSLog(@"Number of %@ instances = %d", self.currentSpec.categoryOfInterest,cOiCount);
    NSLog(@"Number of %@ instances = %d", self.currentSpec.benchmarkCategory,bmcCount);

    
    // Alerts if no instances of selected item
    
    NSString *firstAlertstr=[NSString stringWithFormat:@"No instances of %@",self.currentSpec.categoryOfInterest];
    NSString *secondAlertstr=[NSString stringWithFormat:@"No instances of %@",self.currentSpec.benchmarkCategory];
    NSString *thirdAlertstr=[NSString stringWithFormat:@"No instances in either selected category"];
    
    
    if (cOiCount == 0 && bmcCount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:firstAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
    }
    
    else if (bmcCount == 0 && cOiCount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:secondAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];
        
    }
    
    else if (cOiCount == 0 && bmcCount == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:thirdAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:3];
        [alert show];
    }
    
    else // Instances present in both registers, no alert, sends to delegate for processing
    {
        [self.delegate CvsCViewControllerIsDone:self.currentSpec];
    }
    
    NSLog(@"Number of instances of %@ is %d",self.currentSpec.categoryOfInterest,cOiCount);
    NSLog(@"Number of instances of %@ is %d",self.currentSpec.benchmarkCategory,bmcCount);
    
}


-(void) clearEverything
{
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    
    //    UIButton *selectButton = (UIButton *)[self.view viewWithTag:101];
    [self.mainSelectLabel setText:@"Select first category"];
    [self.timeFrameButton setHidden:YES];
    [self.timeFrameLabel setHidden:YES];
    
    // Set timeFrameButton index so nothing is highlighted
    self.timeFrameButton.selectedSegmentIndex = -1;
    
    for (NSInteger j = 0; j < [self.myTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.myTableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell * cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.myTableView deselectRowAtIndexPath:self.lastIndexPath animated:NO];
        }
    }
    self.lastIndexPath = nil;
    self.firstCategoryLabel.text = @"1st";
    self.secondCategorylabel.text = @"2nd";
    self.firstCategoryLabel.textColor = [UIColor blackColor];
    self.secondCategorylabel.textColor = [UIColor blackColor];
    self.timeFrameLabel.textColor = [UIColor blackColor];
    self.timeFrameLabel.text = @"Timeframe";

    
    [self.myTableView setUserInteractionEnabled:YES];
    clearButton.userInteractionEnabled = NO;
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    doneButton.enabled = NO;
    
    
}

#pragma mark Alert delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self clearEverything]; // Responds to Clear button (cancelButton) on alert
    }
    
}










@end
