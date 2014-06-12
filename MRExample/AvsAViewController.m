//
//  AvsAViewController.m
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "AvsAViewController.h"

@interface AvsAViewController ()

{
    NSFetchedResultsController *frc;
}

@end

@implementation AvsAViewController

NSIndexPath *thisIndexPath;
UITableViewCell *selectedCell;
//bool checksPositiveForInstances;



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
    [self.mainSelectLabel setText:@"Select first activity"];
    self.firstActivityLabel.textColor = [UIColor blackColor];
    self.secondActivityLabel.textColor = [UIColor blackColor];
    self.timeFrameLabel.textColor = [UIColor blackColor];

}

#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell to show the activity's name
    WMDGActivity *thisActivity = [frc objectAtIndexPath:indexPath];
    NSPredicate *categoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", thisActivity.category];
    WMDGCategory *thisCategory = [WMDGCategory MR_findFirstWithPredicate:categoryFinderPredicate];
    int categoryCount = [WMDGCategory MR_countOfEntities];
    
    NSLog(@"There are %d categories", categoryCount);
    NSLog(@"thisCategory is %@",thisCategory.name);
    cell.backgroundColor = thisCategory.color;
    cell.textLabel.textColor = [UIColor blackColor];
    NSAttributedString *attString;
    attString = cell.textLabel.attributedText;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:22];

    [cell.textLabel.text capitalizedString];

    cell.textLabel.text = thisActivity.name;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"aVSaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


//     Section Label

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionLabel = [[[frc sections] objectAtIndex:section]name];
    return [sectionLabel uppercaseString];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIButton *setButton = (UIButton *)[self.view viewWithTag:103];
    setButton.userInteractionEnabled = YES;

    
    NSIndexPath *thisIndexPath = indexPath;
    NSString * alertString = [[NSString alloc] initWithFormat:@"%@ already selected",self.firstActivityLabel.text ];

    
    if (self.lastIndexPath)
    {
        UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        selectedCell = [tableView cellForRowAtIndexPath:thisIndexPath];

//        NSLog(@"lastIndexPath is %@", self.lastIndexPath);
        
        // ******************************* Alert if this is a duplicate selection ******************************
        
        if (lastSelectedCell.textLabel.text == selectedCell.textLabel.text)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString
                                                            message:@"Please select different activity or Cancel"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
 
        }
    }
//    NSLog(@"indexPath is %@", indexPath);
    
    selectedCell = [tableView cellForRowAtIndexPath:thisIndexPath];
//    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:self.lastIndexPath animated:NO];
    
    self.lastIndexPath = thisIndexPath;
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    clearButton.userInteractionEnabled = YES;
    
}



-(void) refreshData
{
    
    frc = [WMDGActivity MR_fetchAllSortedBy:@"category,name"
                                  ascending:YES withPredicate:nil
                                    groupBy:@"category"
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

// Fix the code in this function. Am I going to use a "Set" button after all?

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
    

    
    if ([self.secondActivityLabel.text isEqualToString: @"2nd"])
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
        if ([self.mainSelectLabel.text isEqual: @"Select first activity"])
        {
            self.firstActivityLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.firstActivityLabel.text = selectedCell.textLabel.text;
            [self.mainSelectLabel setText:@"Select second activity"];
        }
        else if ([self.mainSelectLabel.text isEqual: @"Select second activity"])
        {
            self.secondActivityLabel.textColor = Rgb2UIColor(183, 2, 0);
            self.secondActivityLabel.text = selectedCell.textLabel.text;
            [self.mainSelectLabel setText:@"Select timeframe"];

            [self.timeFrameLabel setHidden:NO];

            [self.timeFrameButton setHidden:NO];
            self.myTableView.userInteractionEnabled = NO;
        }
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


- (IBAction)doneButton:(UIBarButtonItem *)sender
{
    if (self.currentSpec.fromDate)
    {
        // Assign activityOfInterest and benchmarkActivity
        // fromDate and toDate already assigned in timeFrameSelector if a time frame has been selected
        
        self.currentSpec.activityOfInterest = self.firstActivityLabel.text;
        self.currentSpec.benchmarkActivity = self.secondActivityLabel.text;
    }
    [self checkForInstances];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
    [self.delegate AvsAViewControllerDidCancel:self.currentSpec];
//    NSLog(@"currentSpec.activityOfInterest is %@",self.currentSpec.activityOfInterest);
//    NSLog(@"delegate is %@",self.delegate);
}

#pragma mark Misc methods

-(void) checkForInstances
{
    NSPredicate *aoiCountFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@ AND ((startTime >= %@ AND stopTime <= %@) OR (startTime <= %@ AND stopTime >= %@) OR (startTime >= %@ AND stopTime == NULL))",self.currentSpec.activityOfInterest,self.currentSpec.fromDate,self.currentSpec.toDate,self.currentSpec.fromDate,self.currentSpec.fromDate,self.currentSpec.fromDate];
    
    NSPredicate *bmaCountFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@ AND ((startTime >= %@ AND stopTime <= %@) OR (startTime <= %@ AND stopTime >= %@) OR (startTime >= %@ AND stopTime == NULL))",self.currentSpec.benchmarkActivity,self.currentSpec.fromDate,self.currentSpec.toDate,self.currentSpec.fromDate,self.currentSpec.fromDate,self.currentSpec.fromDate];
    
    int aOiCount = 0;
    int bmaCount = 0;
    
    aOiCount = [TimedActivity MR_countOfEntitiesWithPredicate:aoiCountFinderPredicate];
    bmaCount = [TimedActivity MR_countOfEntitiesWithPredicate:bmaCountFinderPredicate];
        
//    NSLog(@"Timeframe fromDate is %@",self.currentSpec.fromDate);
//    NSLog(@"Timeframe toDate is %@",self.currentSpec.toDate);
//    NSLog(@"Number of %@ instances = %d", self.currentSpec.activityOfInterest,aOiCount);
//    NSLog(@"Number of %@ instances = %d", self.currentSpec.benchmarkActivity,bmaCount);

    // Alerts if no instances of selected item
    
    NSString *firstAlertstr=[NSString stringWithFormat:@"No instances of %@",self.currentSpec.activityOfInterest];
    NSString *secondAlertstr=[NSString stringWithFormat:@"No instances of %@",self.currentSpec.benchmarkActivity];
    NSString *thirdAlertstr=[NSString stringWithFormat:@"No instances of either selected criteria"];
    
    
    if (aOiCount == 0 && bmaCount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:firstAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
    }
    
    else if (bmaCount == 0 && aOiCount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:secondAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];

    }
    
    else if (aOiCount == 0 && bmaCount == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:thirdAlertstr message:@"Please clear and select a different comparison or timeframe" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:nil];
        [alert setTag:3];
        [alert show];
    }
    
    else // Instances present in both registers, no alert, sends to delegate for processing
    {
        [self.delegate AvsAViewControllerIsDone:self.currentSpec];
    }
    
    NSLog(@"Number of instances of %@ is %d",self.currentSpec.activityOfInterest,aOiCount);
    NSLog(@"Number of instances of %@ is %d",self.currentSpec.benchmarkActivity,bmaCount);

}

-(void) clearEverything
{
    UIButton *clearButton = (UIButton *)[self.view viewWithTag:102];
    
    //    UIButton *selectButton = (UIButton *)[self.view viewWithTag:101];
    [self.mainSelectLabel setText:@"Select first activity"];
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
    self.firstActivityLabel.text = @"1st";
    self.secondActivityLabel.text = @"2nd";
    self.firstActivityLabel.textColor = [UIColor blackColor];
    self.secondActivityLabel.textColor = [UIColor blackColor];
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

