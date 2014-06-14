//
//  HomeViewController.m
//  MRExample
//
//  Created by Tim Jones on 1/15/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

{

}


@end

@implementation HomeViewController

NSFetchedResultsController *actFRC;

NSFetchedResultsController *categoryFRC;

TimedActivity *topActivity;

NSString *cellLabelTempText;
//    NSTimer *timer;
int tapCounter;
NSIndexPath *lastIndexPath;
CustomHVCCell *selectedCell;
NSInteger pulseCycle = 0;



- (void)viewDidLoad
{
    [super viewDidLoad];
    actFRC = [WMDGActivity MR_fetchAllSortedBy:@"category,name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    [self.topPanelView addSubview:self.windowView];
    [self.windowView addSubview:self.durationOrSleepLabel];
    [self.windowView addSubview:self.currentlyTimedLabel];
    [self.windowView addSubview:self.currentTimingLabel];
    [self.dumpMemoryButton setHidden:NO];
    [self.durationOrSleepLabel setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.timeStopperButton.layer.borderWidth = 3.0f;
    self.timeStopperButton.layer.cornerRadius = 8.0f;
    self.timeStopperButton.layer.borderColor = [[UIColor redColor] CGColor];


    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    self.currentTimedActivity = [TimedActivity MR_findFirstOrderedByAttribute:@"startTime" ascending:NO];
    
    NSPredicate *categoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.currentTimedActivity.category];
    WMDGCategory *thisCategory = [WMDGCategory MR_findFirstWithPredicate:categoryFinderPredicate];
    
    
    
    if (self.currentTimedActivity)
    {
        
        if (![self.currentTimedActivity.name isEqualToString:@"Timer Sleeping"])
        {
            [self.durationOrSleepLabel setHidden:NO];
            
            self.durationOrSleepLabel.textColor = thisCategory.color;
            self.currentlyTimedLabel.textColor = thisCategory.color;
            
            self.currentlyTimedLabel.text = self.currentTimedActivity.name;
            
            [self startDurationTimer];
        }
        
        else if ([self.currentTimedActivity.name isEqualToString:@"Timer Sleeping"])
        {
//            self.durationOrSleepLabel.text = self.currentTimedActivity.name;
            self.currentlyTimedLabel.textColor = [UIColor redColor];
            self.currentlyTimedLabel.text = @"Timer Sleeping";
            
            self.durationOrSleepLabel.textColor = [UIColor redColor];
            
            [self.durationOrSleepLabel setHidden:NO];
            [self startDurationTimer];
        }
    }
    
    else
    {
        // Create fresh TimedActivity object
        self.currentTimedActivity = [TimedActivity MR_createInContext:localContext];
        
        // Assign the attributes
        self.currentTimedActivity.name = @"Timer Sleeping";
        self.currentTimedActivity.category = @"Uncharacterized";
        self.currentTimedActivity.startTime = [NSDate date];
        
        [localContext MR_saveToPersistentStoreAndWait];
        
        self.currentlyTimedLabel.textColor = [UIColor redColor];
        self.currentlyTimedLabel.text = @"Timer Sleeping";
        
        self.durationOrSleepLabel.textColor = [UIColor redColor];
        self.durationOrSleepLabel.text = self.currentTimedActivity.name;
        
        [self.durationOrSleepLabel setHidden:NO];
        [self startDurationTimer];
        
        NSString * titleString = [[NSString alloc] initWithFormat:@"No activities available"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:@"Please tap the + button to create activities and categories"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [WMDGActivity MR_countOfEntities];
    NSLog(@"Number of activities is %d",count);

    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.thisCustomHVCCell = [tableView dequeueReusableCellWithIdentifier:@"myCustomHVCCell"];
    
    if (!self.thisCustomHVCCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomHVCCell" bundle:nil] forCellReuseIdentifier:@"myCustomHVCCell"];
        self.thisCustomHVCCell = [tableView dequeueReusableCellWithIdentifier:@"myCustomHVCCell"];
    }
    
    return self.thisCustomHVCCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomHVCCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.thisParticularActivity = [actFRC objectAtIndexPath:indexPath];
    
    
    
    NSPredicate *categoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.thisParticularActivity.category];
    
    self.thisParticularCategory = [WMDGCategory MR_findFirstWithPredicate:categoryFinderPredicate];

    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.thisCustomHVCCell.backgroundView = backgroundView;
    
    for (UIView* view in self.thisCustomHVCCell.contentView.subviews)
    {
        view.backgroundColor = [UIColor clearColor];
    }
    
    UIColor *borderColor = self.thisParticularCategory.color;
    [self.thisCustomHVCCell.contentView setBackgroundColor:[UIColor blackColor]];
    [self.thisCustomHVCCell.contentView.layer setBorderColor:borderColor.CGColor];
    [self.thisCustomHVCCell.contentView.layer setCornerRadius:20.0f];
    [self.thisCustomHVCCell.contentView.layer setBorderWidth:6.0f];

    
    
    self.thisCustomHVCCell.hvcCellActivityLabel.font = [UIFont systemFontOfSize:32];
    self.thisCustomHVCCell.hvcCellActivityLabel.textColor = self.thisParticularCategory.color;
    self.thisCustomHVCCell.hvcCellActivityLabel.text = [self.thisParticularActivity.name capitalizedString];
    

    
    
    self.thisCustomHVCCell.hvcCellCategoryLabel.font = [UIFont systemFontOfSize:12];
    self.thisCustomHVCCell.hvcCellCategoryLabel.textColor = self.thisParticularCategory.color;
    self.thisCustomHVCCell.hvcCellCategoryLabel.text = [self.thisParticularCategory.name uppercaseString];
    
}

#pragma mark - Tableview delegate methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.timeStopperButton setUserInteractionEnabled:YES];

//    CustomHVCCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];

    
    [self stopBlinkTimer];
//    [self zeroTimer];
    
    NSIndexPath *thisIndexPath = indexPath;
    if (lastIndexPath)
    {
//        CustomHVCCell *lastSelectedCell = [tableView cellForRowAtIndexPath:lastIndexPath];
//        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        NSLog(@"lastIndexPath is %@", lastIndexPath);
    }
    NSLog(@"currentIndexPath is %@", lastIndexPath);
    
//    selectedCell = [tableView cellForRowAtIndexPath:thisIndexPath];
    lastIndexPath = thisIndexPath;
    [tableView deselectRowAtIndexPath:lastIndexPath animated:NO];
    
    
    //***********This is the section that needs to be refactored***************
    
    // Pulls up the most recent Activity, i.e., the one being replaced by the one about to be created, the one without a stopTime
    self.previousTimedActivity = [TimedActivity MR_findFirstOrderedByAttribute:@"startTime" ascending:NO];
    
//    NSLog(@"previousTimedActivity is %@",self.previousTimedActivity.name);

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    WMDGActivity *thisActivity = [actFRC objectAtIndexPath:lastIndexPath];
    NSLog(@"thisActivity before 'if' is %@",thisActivity.name);
    
    // Is this the same activity that is already being timed?
    // If so, show alert and do nothing else
    
    NSLog(@"Previously selected activity was %@",self.previousTimedActivity.name);
//    NSLog(@"Just-selected activity is %@",thisCell.textLabel.text);


    if ([self.previousTimedActivity.name isEqualToString:thisActivity.name])
    {
        NSLog(@"***Previous activity is %@",self.previousTimedActivity.name);
        NSLog(@"***Activity just selected is %@",self.thisCustomHVCCell.hvcCellActivityLabel.text);

        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"This activity is currently being timed"
                              message:@"Please select a different activity or Stop Timer"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    // If not, create new TimedActivity object, etc.
    else
    {
        // Create fresh TimedActivity object
//        self.currentTimedActivity = [[TimedActivity alloc]init];
        self.currentTimedActivity = [TimedActivity MR_createInContext:localContext];
        
        // Assign the attributes
        self.currentTimedActivity.name = thisActivity.name;
        self.currentTimedActivity.category = thisActivity.category;
        self.currentTimedActivity.startTime = [NSDate date];
        self.currentTimedActivity.color = thisActivity.toCategory.color;

        
        // Assign stop time to previousTimedActivity
        self.previousTimedActivity.stopTime = self.currentTimedActivity.startTime;
        
        // Calculate previousActivityDuration
        NSTimeInterval previousActivityDuration = [self.previousTimedActivity.stopTime timeIntervalSinceDate:self.previousTimedActivity.startTime];
        
        // Log previousActivityDuration
        self.previousTimedActivity.duration = @(previousActivityDuration);
        
       // Save the current timed activity and the previous timed activity (including duration) to store
        
        [localContext MR_saveToPersistentStoreAndWait];
        
        [self.durationOrSleepLabel setHidden:NO];
        NSPredicate *categoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.currentTimedActivity.category];
        WMDGCategory *thisCategory = [WMDGCategory MR_findFirstWithPredicate:categoryFinderPredicate];

        self.durationOrSleepLabel.textColor = thisCategory.color;
        self.currentlyTimedLabel.textColor = thisCategory.color;
        
        self.currentlyTimedLabel.text = self.currentTimedActivity.name;
        
        
//        [self zeroTimer];
        
        [self startDurationTimer];
        
        [tableView deselectRowAtIndexPath:lastIndexPath animated:NO];
    }
}
//***********This is the section that needs to be refactored***************

#pragma mark Deletion options for test

// Remove option for finished product

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        WMDGActivity *activityToTrash = [actFRC objectAtIndexPath:indexPath];
        
        // Delete the row from the data source
        
        [activityToTrash MR_deleteEntity];
        
        // Now trash everything with the same name in the persistent store
        // Put up an alert warning of complete data loss specific to this activity
        
        NSPredicate *deletionPredicate = [NSPredicate predicateWithFormat:@"name == %@",activityToTrash.name];
        
        [TimedActivity MR_deleteAllMatchingPredicate:deletionPredicate];
        [localContext MR_saveToPersistentStoreAndWait];
        [self refreshData];
    }
}


-(void) refreshData
{
    actFRC = [WMDGActivity MR_fetchAllSortedBy:@"category,name"
                                  ascending:YES withPredicate:nil
                                    groupBy:nil
                                   delegate:nil];
    [self.myTableView reloadData];
}



- (IBAction)dumpMemory:(UIButton *)sender
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [TimedActivity MR_truncateAllInContext:localContext];
    [localContext MR_saveToPersistentStoreAndWait];
    [self refreshData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    if ([[segue identifier] isEqualToString:@"addActivity"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddActivityViewController *aavc = (AddActivityViewController *)navController.topViewController;
        aavc.delegate = self;
        WMDGActivity *addedActivity = (WMDGActivity *)[WMDGActivity MR_createInContext:localContext];
        aavc.thisActivity = addedActivity;
    }
    
//    else if ([[segue identifier] isEqualToString:@"addCategory"])
//    {
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
//        AddCategoryViewController *acvc = (AddCategoryViewController *)navController.topViewController;
//        acvc.delegate = self;
//    }
}


#pragma mark - AddViewControllerDelegate stuff

-(void) addActivityViewControllerDidSave
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    int numberOfActivities = [WMDGActivity MR_countOfEntities];
    
    NSLog(@"Number of activities is %d",numberOfActivities);
    [self refreshData];
}

-(void) addActivityViewControllerDidCancel:(WMDGActivity *) activityToDelete
{
    [activityToDelete MR_deleteEntity];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self refreshData];
}


#pragma mark - AddCatControllerDelegate stuff

//-(void) addCatControllerDidSave
//{
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    [localContext MR_saveToPersistentStoreAndWait];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

//    NSFetchedResultsController *testFRC;
//    NSArray *array;
//    array = [WMDGCategory MR_findAll];
//    NSLog(@"Number of WMDGCategory objects in store is %d", [[testFRC sections] count]);
//    NSIndexPath *indexPath;
//    NSLog(@"Name of the top Category is %@", [[array objectAtIndex:0]name]);

//    [self refreshData];
//}
//
//-(void) addCatControllerDidCancel:(WMDGCategory *) categoryToDelete
//{
//    [categoryToDelete MR_deleteEntity];
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    [localContext MR_saveToPersistentStoreAndWait];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self refreshData];

//}

#pragma mark - Label handling methods

-(void)updateDurationLabel
{
    //Which calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Gets the componentized interval from the most recent time an activity was tapped until now
    
    NSDateComponents *components= [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self.startTime toDate:[NSDate date] options:0];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds =[components second];
    
    // Converts the components to a string and displays it in the duration label, updated via the timer
    
    cellLabelTempText = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
    self.durationOrSleepLabel.text = cellLabelTempText;
}

-(void) startDurationTimer
{
    [self stopBlinkTimer];
    [self stopDurationTimer];
    self.startTime = self.currentTimedActivity.startTime;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(updateDurationLabel) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
    
    
}

-(void) startBlinkTimer
{
    [self stopBlinkTimer];
    self.sleepLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(blinkSleepLabel) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.sleepLabelTimer
                                 forMode:NSRunLoopCommonModes];
    
}


-(void) blinkSleepLabel
{
    
    if (pulseCycle == 0)
    {
        [UIView transitionWithView:self.durationOrSleepLabel duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.durationOrSleepLabel.textColor = [UIColor clearColor];
        } completion:nil];
        
        pulseCycle = 1;
    }
    else if (pulseCycle == 1)
    {
        [UIView transitionWithView:self.durationOrSleepLabel duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.durationOrSleepLabel.textColor = [UIColor redColor];
        } completion:nil];
        
        pulseCycle = 0;
    }
}

-(void) stopBlinkTimer
{
    [self.sleepLabelTimer invalidate];
    self.sleepLabelTimer = nil;
}


-(void) zeroTimer
{
    NSString * cellLabelZeroText = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",0,0,0,0];
    self.durationOrSleepLabel.text = cellLabelZeroText;
    
}


-(void) stopDurationTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)stopTimerButton:(UIButton *)sender
{
    [self stopDurationTimer];
    self.durationOrSleepLabel.textColor = [UIColor redColor];

    self.previousTimedActivity = self.currentTimedActivity;
    
    NSManagedObjectContext *thisContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    // Create fresh TimedActivity object
    self.currentTimedActivity = [TimedActivity MR_createInContext:thisContext];
    
    // Assign the attributes
    self.currentTimedActivity.name = @"Timer Sleeping";
    self.currentTimedActivity.category = @"Uncharacterized";
    self.currentTimedActivity.startTime = [NSDate date];
    
    // Assign stop time to previousTimedActivity
    self.previousTimedActivity.stopTime = self.currentTimedActivity.startTime;
    
    // Calculate previousActivityDuration
    NSTimeInterval previousActivityDuration = [self.previousTimedActivity.stopTime timeIntervalSinceDate:self.previousTimedActivity.startTime];
    
    // Log previousActivityDuration
    self.previousTimedActivity.duration = @(previousActivityDuration);
    
    
    // Save the current timed activity and the previous timed activity (including duration) to store
    
    [thisContext MR_saveToPersistentStoreAndWait];
    
    // Deselect all the tableview cells
    
        for (NSInteger j = 0; j < [self.myTableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [self.myTableView numberOfRowsInSection:j]; ++i)
            {
                UITableViewCell * cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                [self.myTableView deselectRowAtIndexPath:lastIndexPath animated:NO];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    
    self.currentlyTimedLabel.text = @"Timer Sleeping";
    self.currentlyTimedLabel.textColor = [UIColor redColor];
    
    [self startDurationTimer];
    [self.timeStopperButton setUserInteractionEnabled:NO];
}



@end












