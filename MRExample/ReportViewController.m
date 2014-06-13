//
//  ReportViewController.m
//  MRExample
//
//  Created by Tim Jones on 12/1/13.
//  Copyright (c) 2013 TDJ. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()


@end

NSNumber *activityOfInterestDurationTotal;
NSNumber *benchmarkActivityDurationTotal;
NSNumber *categoryOfInterestDurationTotal;
NSNumber *benchmarkCategoryDurationTotal;

//RiserBar *thisRiser;


//double durationTotal;
double focusItemPercent;
double focusItemDuration;
double benchmarkItemDuration;
double benchmarkItemPercent;

// Edge case intervals

double earlyEdgeCaseAoIInterval;
double lateEdgeCaseAoIInterval;

double earlyEdgeCaseBMAInterval;
double lateEdgeCaseBMAInterval;

double earlyEdgeCaseCoIInterval;
double lateEdgeCaseCoIInterval;

double earlyEdgeCaseBMCInterval;
double lateEdgeCaseBMCInterval;


int     goButtonKey;
int     bIndex;

SearchSpecs * SpecItem;
TimedActivity *firstActivity;

NSString *focusItemName;
NSString *benchmarkItemName;
NSString *actualDurationFocusItem;
NSString *actualDurationBenchmarkItem;

NSString *detailPredicateName;
NSString *detailPredicateCategory;


UIButton *firstLabel;
UIButton *secondLabel;

UIColor *startColor1;
UIColor *endColor1;
UIColor *startColor2;
UIColor *endColor2;




@implementation ReportViewController



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
    [self.chartView setUserInteractionEnabled:YES];
    self.comparisonSelectorActionSheet.delegate = self;
    [self.goButton setUserInteractionEnabled:NO];
    UIImage *image = [UIImage imageNamed:@"Paper background.png"];
    self.chartView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.selectCompButton.layer.borderWidth = 3.0f;
    self.selectCompButton.layer.cornerRadius = 20.0f;
    self.selectCompButton.layer.borderColor = [[UIColor greenColor] CGColor];

    self.goButton.layer.borderWidth = 3.0f;
    self.goButton.layer.cornerRadius = 20.0f;
    self.goButton.layer.borderColor = [[UIColor redColor] CGColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons and Segues




- (IBAction)goButtonAction:(id)sender
{
    
    switch (goButtonKey)
    {
        case 0:
        {
            
        }
            break;
            
        case 1:
        {
            [self handleAvsAAction];
            [self doTheMathAvsA];
            [self makeBarChart];
        }
            
            break;
            
        case 2:
        {
            [self handleCvsCAction];
            [self doTheMathCvsC];
            [self makeBarChart];
        }
            
            
        default:
            break;
    }
    [self.goButton setUserInteractionEnabled:NO];

}
- (IBAction)selectCompButton:(UIButton *)sender
{
//    NSLog(@"bIndex = %d", bIndex);

    self.comparisonSelectorActionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Select comparison mode"
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"Activity vs Activity", @"Category vs Category",  @"Activity vs All",  @"Category vs All", nil];
    
    [self.comparisonSelectorActionSheet showInView:self.selectCompButton];
    bIndex = 0;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
            [self performSegueWithIdentifier:@"aVsAModal" sender:self.comparisonSelectorActionSheet];
            break;
        case 1:
            [self performSegueWithIdentifier:@"cVsCModal" sender:self.comparisonSelectorActionSheet];
            break;
    }
    bIndex = buttonIndex;
//    NSLog(@"bIndex = %d", bIndex);
}





-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:sender

{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];

    
    if (sender == self.comparisonSelectorActionSheet)
    {
        
        switch (bIndex)
        {
            case 0:
            {
                UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
                AvsAViewController *aVSaVC = (AvsAViewController *)navController.topViewController;
                aVSaVC.delegate = self;
                
                [SearchSpecs MR_truncateAllInContext:localContext];
                [localContext MR_saveToPersistentStoreAndWait];

                SearchSpecs *xferSpec = (SearchSpecs *)[SearchSpecs MR_createInContext:localContext];
                aVSaVC.currentSpec = xferSpec;

            }
                break;
                
            case 1:
            {
                UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
                CvsCViewController *cVScVC = (CvsCViewController *)navController.topViewController;
                cVScVC.delegate = self;
                
                [SearchSpecs MR_truncateAllInContext:localContext];
                [localContext MR_saveToPersistentStoreAndWait];

                SearchSpecs *xferSpec = (SearchSpecs *)[SearchSpecs MR_createInContext:localContext];
                cVScVC.currentSpec = xferSpec;

            }
                break;
                
            default:
                break;
        }
    }
    
    
    // I need to prepare CategoryDetailVC with appropriate properties, add detailEndDate, etc.
    
    else if (sender == firstLabel || secondLabel)
    {
        //                UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        DetailViewController *DVC = (DetailViewController *)segue.destinationViewController;
        DVC.detailFocusItem = focusItemName;
        DVC.detailBenchmarkItem = benchmarkItemName;
        DVC.detailStartDate = self.thisSpec.fromDate;
        DVC.detailEndDate = self.thisSpec.toDate;
        DVC.activityOrCategory = bIndex;
        
        DVC.itemOfInterestColor = endColor1;
        DVC.benchmarkItemColor = endColor2;
    }
    
    
}


#pragma mark - User input delegate methods

-(void) AvsAViewControllerIsDone: (SearchSpecs *) specForGraph
{
//    NSLog(@"focusActivity is %@", specForGraph.activityOfInterest);
//    NSLog(@"benchmarkActivity is %@", specForGraph.benchmarkActivity);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"MM/dd/yyyy hh:mm:ss"];
//    NSLog(@"fromDate for this spec is %@",[dateFormat stringFromDate:specForGraph.fromDate]);
    
    // Identify the action to be invoked by the goButton
    
    goButtonKey = 1;
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    [localContext MR_saveToPersistentStoreAndWait];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.chartView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    UILabel * mainChartLabel;
    mainChartLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.chartView addSubview:mainChartLabel];
    mainChartLabel.frame = CGRectMake(self.chartView.bounds.origin.x + 20, self.chartView.bounds.origin.y, self.chartView.frame.size.width - 40, 40);
    mainChartLabel.backgroundColor = [UIColor clearColor];
    mainChartLabel.textColor = [UIColor blackColor];
    [mainChartLabel setFont:[UIFont boldSystemFontOfSize:20]];
    mainChartLabel.numberOfLines = 1;
    mainChartLabel.textAlignment = NSTextAlignmentCenter;
//    UIColor *AvsABGColor = Rgb2UIColor(255, 232, 179);
//    self.chartView.backgroundColor = AvsABGColor;
    NSString *chartLabelText = [NSString stringWithFormat:@"%@ VS %@",specForGraph.activityOfInterest,specForGraph.benchmarkActivity];
    [mainChartLabel setText:chartLabelText];
    mainChartLabel.numberOfLines = 1;
    mainChartLabel.minimumScaleFactor = 8./mainChartLabel.font.pointSize;
    mainChartLabel.adjustsFontSizeToFitWidth = YES;

    [mainChartLabel setHidden:YES];
    [self.goButton setUserInteractionEnabled:YES];

    
}

-(void) AvsAViewControllerDidCancel:(SearchSpecs *) specToDelete
{
    goButtonKey = 0;
    [specToDelete MR_deleteEntity];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.goButton setUserInteractionEnabled:NO];

}


-(void) CvsCViewControllerIsDone: (SearchSpecs *) specForGraph
{
//    NSLog(@"focusCategory is %@", specForGraph.categoryOfInterest);
//    NSLog(@"benchmarkCategory is %@", specForGraph.benchmarkCategory);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"MM/dd/yyyy hh:mm:ss"];
//    NSLog(@"fromDate for this spec is %@",[dateFormat stringFromDate:specForGraph.fromDate]);
    
    // Identify the action to be invoked by the goButton
    
    goButtonKey = 2;
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    [localContext MR_saveToPersistentStoreAndWait];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.chartView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    UILabel * mainChartLabel;
    mainChartLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.chartView addSubview:mainChartLabel];
    mainChartLabel.frame = CGRectMake(self.chartView.bounds.origin.x + 20, self.chartView.bounds.origin.y, self.chartView.frame.size.width - 40, 40);
    mainChartLabel.backgroundColor = [UIColor clearColor];
    mainChartLabel.textColor = [UIColor blackColor];
    [mainChartLabel setFont:[UIFont boldSystemFontOfSize:20]];
    mainChartLabel.numberOfLines = 1;
    mainChartLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *chartLabelText = [NSString stringWithFormat:@"%@ VS %@",specForGraph.categoryOfInterest,specForGraph.benchmarkCategory];
    [mainChartLabel setText:chartLabelText];
    mainChartLabel.numberOfLines = 1;
    mainChartLabel.minimumScaleFactor = 8./mainChartLabel.font.pointSize;
    mainChartLabel.adjustsFontSizeToFitWidth = YES;

    [mainChartLabel setHidden:NO];
    [self.goButton setUserInteractionEnabled:YES];

    
}

-(void) CvsCViewControllerDidCancel:(SearchSpecs *) specToDelete
{
    goButtonKey = 0;
    [specToDelete MR_deleteEntity];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.goButton setUserInteractionEnabled:NO];

}

#pragma mark - Go button case handlers

-(void) handleAvsAAction
{
    NSArray *searchSpecsArray = [SearchSpecs MR_findAll];
    self.thisSpec = [searchSpecsArray objectAtIndex:0];
}

-(void) edgeCaseFinder
{
    
    earlyEdgeCaseAoIInterval = 0.0;
    lateEdgeCaseAoIInterval = 0.0;
    
    earlyEdgeCaseBMAInterval = 0.0;
    lateEdgeCaseBMAInterval = 0.0;
    
    
    earlyEdgeCaseCoIInterval = 0.0;
    lateEdgeCaseCoIInterval = 0.0;
    
    earlyEdgeCaseBMCInterval = 0.0;
    lateEdgeCaseBMCInterval = 0.0;


    // Early edge case predicate
    
    
    NSPredicate *earlyEdgeCaseActivityPredicate = [NSPredicate predicateWithFormat:@"startTime <= %@ AND stopTime >= %@",self.thisSpec.fromDate,self.thisSpec.fromDate];
    
    // Late edge case predicate
    
    NSPredicate *lateEdgeCaseActivityPredicate = [NSPredicate predicateWithFormat:@"(startTime <= %@) AND (stopTime == NULL)",self.thisSpec.toDate];
    
    
    // This yields an object that's wrapped around the toDate. It could be any activity, any category
    
    TimedActivity *earlyEdgeCaseObject = [TimedActivity MR_findFirstWithPredicate:earlyEdgeCaseActivityPredicate];
    
    NSLog(@"Early edge case object is %@. It's duration is %@",earlyEdgeCaseObject.name,earlyEdgeCaseObject.duration);
    
    NSLog(@"The startTime of %@ = %@, and the stopTime = %@",earlyEdgeCaseObject.name,earlyEdgeCaseObject.startTime,earlyEdgeCaseObject.stopTime);
    
    // This yields an object that's wrapped around the toDate. It could be any activity, any category
    
    TimedActivity *lateEdgeCaseObject = [TimedActivity MR_findFirstWithPredicate:lateEdgeCaseActivityPredicate];
    
    NSLog(@"Late edge case object is %@. It's duration is %@",lateEdgeCaseObject.name,lateEdgeCaseObject.duration);
    
    NSLog(@"The startTime of %@ = %@, and the stopTime = %@",lateEdgeCaseObject.name,lateEdgeCaseObject.startTime,lateEdgeCaseObject.stopTime);

    
    // If else sorts out whether the early and late edge case objects are relevant, and determines edge interval if so
    
    // Handles both Activities and Categories
    
    if (earlyEdgeCaseObject)
    {
        if ([self.thisSpec.activityOfInterest isEqualToString:earlyEdgeCaseObject.name])
        {
            earlyEdgeCaseAoIInterval = [earlyEdgeCaseObject.stopTime timeIntervalSinceDate:self.thisSpec.fromDate];
            NSLog(@"Early edge AoI object is %@",earlyEdgeCaseObject.name);
            NSLog(@"Interval for this activity is %f", earlyEdgeCaseAoIInterval);

        }
        
        else if ([self.thisSpec.benchmarkActivity isEqualToString:earlyEdgeCaseObject.name])
        {
            earlyEdgeCaseBMAInterval = [earlyEdgeCaseObject.stopTime timeIntervalSinceDate:self.thisSpec.fromDate];
            NSLog(@"Early edge case BMA object is %@",earlyEdgeCaseObject.name);
            NSLog(@"Interval for this activity is %f", earlyEdgeCaseBMAInterval);

        }
        
        else if ([self.thisSpec.categoryOfInterest isEqualToString:earlyEdgeCaseObject.category])
        {
            earlyEdgeCaseCoIInterval = [earlyEdgeCaseObject.stopTime timeIntervalSinceDate:self.thisSpec.fromDate];
        }
        
        
        else if ([self.thisSpec.benchmarkCategory isEqualToString:earlyEdgeCaseObject.category])
        {
            earlyEdgeCaseBMCInterval = [earlyEdgeCaseObject.stopTime timeIntervalSinceDate:self.thisSpec.fromDate];
        }

    }
    
    if (lateEdgeCaseObject)
    {
        if ([self.thisSpec.activityOfInterest isEqualToString:lateEdgeCaseObject.name])
        {
            lateEdgeCaseAoIInterval = [lateEdgeCaseObject.startTime timeIntervalSinceDate:self.thisSpec.toDate];
            NSLog(@"Late edge case object is %@",lateEdgeCaseObject.name);
            NSLog(@"Late edge case lateEdgeCaseAoIInterval is %f", lateEdgeCaseAoIInterval);
            NSLog(@"This should appear only if the Late edge case object is the AOI");

        }
        
        else if ([self.thisSpec.benchmarkActivity isEqualToString:lateEdgeCaseObject.name])
        {
            lateEdgeCaseBMAInterval = [lateEdgeCaseObject.startTime timeIntervalSinceDate:self.thisSpec.toDate];
            NSLog(@"Late edge case object is %@",lateEdgeCaseObject.name);
            NSLog(@"Late edge case lateEdgeCaseBMAInterval is %f", lateEdgeCaseBMAInterval);
            NSLog(@"This should appear only if the Early edge case object is the BMA");

        }
        
        else if ([self.thisSpec.categoryOfInterest isEqualToString:lateEdgeCaseObject.category])
        {
            lateEdgeCaseCoIInterval = [lateEdgeCaseObject.startTime timeIntervalSinceDate:self.thisSpec.toDate];
        }
        
        
        else if ([self.thisSpec.benchmarkCategory isEqualToString:lateEdgeCaseObject.category])
        {
            lateEdgeCaseBMCInterval = [lateEdgeCaseObject.startTime timeIntervalSinceDate:self.thisSpec.toDate];
        }
    }
}

-(void) doTheMathAvsA
{
    
    double focusActivityPercent;
    double benchmarkActivityPercent;
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];

#pragma mark AvsA edge case predicates

    
    [self edgeCaseFinder];


    //Primary predicates for aggregate ops
    
    //************************************************** Changed to find only fully encapsulated activities

    NSPredicate *activityOfInterestPredicate = [NSPredicate predicateWithFormat:@"name == %@ AND startTime >= %@ AND stopTime <= %@",self.thisSpec.activityOfInterest,self.thisSpec.fromDate,self.thisSpec.toDate];
    

    NSPredicate *benchmarkActivityPredicate = [NSPredicate predicateWithFormat:@"name == %@ AND startTime >= %@ AND stopTime <= %@",self.thisSpec.benchmarkActivity, self.thisSpec.fromDate,self.thisSpec.toDate];
    
    int encapsulatedAOIcount = 0;
    int encapsulatedBMAcount = 0;
    
    encapsulatedAOIcount = [TimedActivity MR_countOfEntitiesWithPredicate:activityOfInterestPredicate];
    encapsulatedBMAcount = [TimedActivity MR_countOfEntitiesWithPredicate:benchmarkActivityPredicate];
    
    NSLog(@"Number of fully encapsulated AOI objects within timeframe = %d",encapsulatedAOIcount);
    NSLog(@"Number of fully encapsulated BMA objects within timeframe = %d",encapsulatedBMAcount);


    // Get durations using predicates and aggregate ops
    
    activityOfInterestDurationTotal = [TimedActivity MR_aggregateOperation:@"sum:" onAttribute:@"duration" withPredicate:activityOfInterestPredicate];
    NSLog(@"The sum of durations for encapsulated instances of %@ within the current timeframe is %.2f", self.thisSpec.activityOfInterest,[activityOfInterestDurationTotal doubleValue]);
    
    benchmarkActivityDurationTotal = [TimedActivity MR_aggregateOperation:@"sum:" onAttribute:@"duration" withPredicate:benchmarkActivityPredicate];
    NSLog(@"The sum of durations for encapsulated instances of %@ within the current timeframe is %.2f", self.thisSpec.benchmarkActivity,[benchmarkActivityDurationTotal doubleValue]);
    

    // Get the total and respective percentages of the totalled durations from the criteria distilled in handleAvsAAction
    
    double activityDurationTotal;
    double focusActivityDuration = [activityOfInterestDurationTotal doubleValue];
    double benchmarkActivityDuration = [benchmarkActivityDurationTotal doubleValue];
    
    
#pragma mark end case math AvsA

    // Add end case intervals to aggregate durations
    
    focusActivityDuration = focusActivityDuration + earlyEdgeCaseAoIInterval + abs(lateEdgeCaseAoIInterval);
    benchmarkActivityDuration = benchmarkActivityDuration + earlyEdgeCaseBMAInterval + abs(lateEdgeCaseBMAInterval);
    
    NSLog(@"focusActivityDuration = %f + %f + %f",focusActivityDuration,earlyEdgeCaseAoIInterval,lateEdgeCaseAoIInterval);
    NSLog(@"benchmarkActivityDuration = %f + %f + %f",benchmarkActivityDuration,earlyEdgeCaseBMAInterval,lateEdgeCaseBMAInterval);

    // These are the numbers that drive the bar chart animations
    
    activityDurationTotal = focusActivityDuration + benchmarkActivityDuration;
    focusActivityPercent = ((focusActivityDuration / activityDurationTotal) * 100);
    benchmarkActivityPercent = ((benchmarkActivityDuration / activityDurationTotal) * 100);
    
    // These things get passed to the chart, appropriately named whether it's an activity or a category
    
    focusItemName = [self.thisSpec activityOfInterest];
    benchmarkItemName = [self.thisSpec benchmarkActivity];
    
    focusItemDuration = focusActivityDuration;
    benchmarkItemDuration = benchmarkActivityDuration;
    
    focusItemPercent = focusActivityPercent;
    benchmarkItemPercent = benchmarkActivityPercent;
    
    
    [self focusItemDurationCalculator];
    [self benchmarkItemDurationCalculator];
}

-(void) handleCvsCAction
{
    NSArray *searchSpecsArray = [SearchSpecs MR_findAll];
    self.thisSpec = [searchSpecsArray objectAtIndex:0];
}

-(void) doTheMathCvsC
{
    
    double focusCategoryPercent;
    double benchmarkCategoryPercent;
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    
#pragma mark AvsA edge case predicates

    
    [self edgeCaseFinder];

    
    //Primary predicates for aggregate ops
    
    //************************************************** Changed to find only fully encapsulated activities
    
    NSPredicate *categoryOfInterestPredicate = [NSPredicate predicateWithFormat:@"category == %@ AND startTime >= %@ AND stopTime <= %@",self.thisSpec.categoryOfInterest,self.thisSpec.fromDate,self.thisSpec.toDate];
    
    
    NSPredicate *benchmarkCategoryPredicate = [NSPredicate predicateWithFormat:@"category == %@ AND startTime >= %@ AND stopTime <= %@",self.thisSpec.benchmarkCategory, self.thisSpec.fromDate,self.thisSpec.toDate];
    
    int encapsulatedCOIcount = 0;
    int encapsulatedBMCcount = 0;
    
    encapsulatedCOIcount = [TimedActivity MR_countOfEntitiesWithPredicate:categoryOfInterestPredicate];
    encapsulatedBMCcount = [TimedActivity MR_countOfEntitiesWithPredicate:benchmarkCategoryPredicate];
    
    NSLog(@"Number of fully encapsulated AOI objects within timeframe = %d",encapsulatedCOIcount);
    NSLog(@"Number of fully encapsulated BMA objects within timeframe = %d",encapsulatedCOIcount);

    // Get durations using predicates and aggregate ops
    
    categoryOfInterestDurationTotal = [TimedActivity MR_aggregateOperation:@"sum:" onAttribute:@"duration" withPredicate:categoryOfInterestPredicate];
    NSLog(@"The sum of durations for encapsulated instances of %@ within the current timeframe is %.2f", self.thisSpec.categoryOfInterest,[categoryOfInterestDurationTotal doubleValue]);
    
    benchmarkCategoryDurationTotal = [TimedActivity MR_aggregateOperation:@"sum:" onAttribute:@"duration" withPredicate:benchmarkCategoryPredicate];
    NSLog(@"The sum of durations for encapsulated instances of %@ within the current timeframe is %.2f", self.thisSpec.benchmarkCategory,[benchmarkCategoryDurationTotal doubleValue]);
    
    
    // Get the total and respective percentages of the totalled durations from the criteria distilled in handleAvsAAction
    
    double categoryDurationTotal;
    double focusCategoryDuration = [categoryOfInterestDurationTotal doubleValue];
    double benchmarkCategoryDuration = [benchmarkCategoryDurationTotal doubleValue];
    
    
#pragma mark end case math CvsC
    
    // Add end case intervals to aggregate durations
    
    focusCategoryDuration = focusCategoryDuration + earlyEdgeCaseCoIInterval + abs(lateEdgeCaseCoIInterval);
    benchmarkCategoryDuration = benchmarkCategoryDuration + earlyEdgeCaseBMCInterval + abs(lateEdgeCaseBMCInterval);
    
    NSLog(@"focusCategoryDuration = %f + %f + %f",focusCategoryDuration,earlyEdgeCaseCoIInterval,lateEdgeCaseCoIInterval);
    NSLog(@"benchmarkCategoryDuration = %f + %f + %f",benchmarkCategoryDuration,earlyEdgeCaseBMCInterval,lateEdgeCaseBMCInterval);

    
    // These are the numbers that drive the bar chart animations
    
    categoryDurationTotal = focusCategoryDuration + benchmarkCategoryDuration;
    focusCategoryPercent = ((focusCategoryDuration / categoryDurationTotal) * 100);
    benchmarkCategoryPercent = ((benchmarkCategoryDuration / categoryDurationTotal) * 100);
    // These things get passed to the chart, appropriately named whether it's an activity or a category
    
    focusItemName = [self.thisSpec categoryOfInterest];
    benchmarkItemName = [self.thisSpec benchmarkCategory];

    focusItemDuration = focusCategoryDuration;
    benchmarkItemDuration = benchmarkCategoryDuration;
    
    focusItemPercent = focusCategoryPercent;
    benchmarkItemPercent = benchmarkCategoryPercent;
    
    [self focusItemDurationCalculator];
    [self benchmarkItemDurationCalculator];
}


#pragma mark Miscellaneous methods

-(void) focusItemDurationCalculator
{
    NSInteger days = ((NSInteger) focusItemDuration) / (60 * 60 * 24);
    NSInteger hours = (((NSInteger) focusItemDuration) / (60 * 60)) - (days * 24);
    NSInteger minutes = (((NSInteger) focusItemDuration) / 60) - (days * 24 * 60) - (hours * 60);
    NSInteger seconds = ((NSInteger) round(focusItemDuration)) % 60;
    
    actualDurationFocusItem = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
//    NSLog(@"FocusItemDuration, raw = %f",focusItemDuration);
//    NSLog(@"actualDurationFocusItem, calculated = %@",actualDurationFocusItem);

}

-(void) benchmarkItemDurationCalculator
{
    NSInteger days = ((NSInteger) benchmarkItemDuration) / (60 * 60 * 24);
    NSInteger hours = (((NSInteger) benchmarkItemDuration) / (60 * 60)) - (days * 24);
    NSInteger minutes = (((NSInteger) benchmarkItemDuration) / 60) - (days * 24 * 60) - (hours * 60);
    NSInteger seconds = ((NSInteger) round(benchmarkItemDuration)) % 60;
    
    actualDurationBenchmarkItem = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
//    NSLog(@"benchmarkItemDuration, raw = %f",benchmarkItemDuration);
//    NSLog(@"actualDurationBenchmarkItem, calculated = %@",actualDurationBenchmarkItem);

}





-(void) makeBarChart
{
    RiserBar *thisRiser;
    firstLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    secondLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSPredicate *aoiFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.thisSpec.activityOfInterest];
    WMDGActivity *AOI = [WMDGActivity MR_findFirstWithPredicate:aoiFinderPredicate];
    NSPredicate *aoiCategoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", AOI.category];
    WMDGCategory *aoiCategory = [WMDGCategory MR_findFirstWithPredicate:aoiCategoryFinderPredicate];

    
    

    NSPredicate *bmaFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.thisSpec.benchmarkActivity];
    WMDGActivity *BMA = [WMDGActivity MR_findFirstWithPredicate:bmaFinderPredicate];
    NSPredicate *bmaCategoryFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", BMA.category];
    WMDGCategory *bmaCategory = [WMDGCategory MR_findFirstWithPredicate:bmaCategoryFinderPredicate];

    
    

    NSPredicate *coiFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.thisSpec.categoryOfInterest];
    WMDGCategory *COI = [WMDGCategory MR_findFirstWithPredicate:coiFinderPredicate];
    NSLog(@"self.thisSpec.categoryOfInterest is %@",self.thisSpec.categoryOfInterest);
    
    
    NSPredicate *BMCFinderPredicate = [NSPredicate predicateWithFormat:@"name == %@", self.thisSpec.benchmarkCategory];
    WMDGCategory *BMC = [WMDGCategory MR_findFirstWithPredicate:BMCFinderPredicate];
    NSLog(@"self.thisSpec.benchmarkCategory is %@",self.thisSpec.benchmarkCategory);



    // Bar colors
    
    
    if (goButtonKey == 1) // Activity bar colors
    {
        // AOI colors
        startColor1 = [UIColor whiteColor];
        endColor1 = aoiCategory.color;
        
        // BMA colors
        startColor2 = [UIColor whiteColor];
        endColor2 = bmaCategory.color;
    }
    
    else if (goButtonKey == 2) // Category bar colors
    {
        // COI colors
        startColor1 = [UIColor whiteColor];
        endColor1 = COI.color;
        NSLog(@"COI.color is %@",COI.color);
        
        
        // BMC colors
        startColor2 = [UIColor whiteColor];
        endColor2 = BMC.color;
        NSLog(@"BMC.color is %@",BMC.color);

    }
    else if (goButtonKey == 0)
    {
        startColor1 = [UIColor blackColor];
        endColor1 = [UIColor greenColor];
        startColor2 = [UIColor blackColor];
        endColor2 = [UIColor greenColor];
    }

// Here's the entry point if I have more than 2 risers
    
for(int i=0; i<2; i++)
{
    thisRiser = [[RiserBar alloc] initWithFrame:CGRectZero];
    thisRiser.tag = i+1;
    [self.chartView addSubview:thisRiser];
}

    // Calculate final dimensions of risers
int barWidth = self.chartView.bounds.size.width /((2 * 2) -1);
int focusBarEndHeight = (self.chartView.bounds.size.height - 95) * (focusItemPercent / 100);
int benchmarkBarEndHeight = (self.chartView.bounds.size.height - 95) * (benchmarkItemPercent / 100);

// Create the bars

for (thisRiser in self.chartView.subviews)
{
    
    switch (thisRiser.tag)
    {
        case 1:
        {
            [self.chartView addSubview:firstLabel];
            [firstLabel setHidden:YES];


            [UIView animateWithDuration:.6
                                  delay:.2
                                options: UIViewAnimationCurveEaseOut
                             animations:^
             {
                 // Starting state
                 thisRiser.frame = CGRectMake(35, self.chartView.frame.size.height, barWidth, 0);
                 thisRiser.backgroundColor = startColor1;
                 
                 // End state
                 thisRiser.frame = CGRectMake(35, self.chartView.frame.size.height, barWidth, -focusBarEndHeight);
                 thisRiser.backgroundColor = endColor1;
                 thisRiser.layer.shadowColor = [[UIColor blackColor] CGColor];
                 thisRiser.layer.shadowOpacity = 0.7;
                 thisRiser.layer.shadowRadius = 4.0;
                 thisRiser.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
                 thisRiser.layer.shadowPath = [UIBezierPath bezierPathWithRect:thisRiser.bounds].CGPath;
             }
                             completion:^(BOOL finished)
             {
                 
                 
                 firstLabel.frame = CGRectMake(thisRiser.frame.origin.x, thisRiser.frame.origin.y - 65, barWidth, 60);
                 [firstLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                 firstLabel.titleLabel.numberOfLines = 0;
                 firstLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
                 [firstLabel setTitle:[NSString stringWithFormat:@"%@\n%.2f%%\nTime--%@",focusItemName,focusItemPercent,actualDurationFocusItem] forState:UIControlStateNormal];
                 firstLabel.backgroundColor = [UIColor clearColor];
                 [firstLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [firstLabel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                 [firstLabel setHidden:NO];
                 [firstLabel addTarget:self action:@selector(firstLabelAction:) forControlEvents:UIControlEventTouchUpInside];
                 [firstLabel setUserInteractionEnabled:YES];
                 [thisRiser setUserInteractionEnabled:YES];


//                 NSLog(@"Done!");
             }];
        }
            break;
            
        case 2:
            
        {
            [self.chartView addSubview:secondLabel];
            [secondLabel setHidden:YES];


            [UIView animateWithDuration:.6
                                  delay:.2
                                options: UIViewAnimationCurveEaseOut
                             animations:^
             {
                 thisRiser.frame = CGRectMake(barWidth + 70, self.chartView.frame.size.height, barWidth, 0);
                 thisRiser.backgroundColor = startColor2;
                 thisRiser.frame = CGRectMake(barWidth + 70, self.chartView.frame.size.height, barWidth, -benchmarkBarEndHeight);
                 thisRiser.backgroundColor = endColor2;
                 thisRiser.layer.shadowColor = [[UIColor blackColor] CGColor];
                 thisRiser.layer.shadowOpacity = 0.7;
                 thisRiser.layer.shadowRadius = 4.0;
                 thisRiser.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
                 thisRiser.layer.shadowPath = [UIBezierPath bezierPathWithRect:thisRiser.bounds].CGPath;
                 
             }
                             completion:^(BOOL finished)
             {
                 secondLabel.frame = CGRectMake(thisRiser.frame.origin.x, thisRiser.frame.origin.y -65, barWidth, 60);
                 [secondLabel setTitle:[NSString stringWithFormat:@"%@\n%.2f%%\nTime--%@",benchmarkItemName,benchmarkItemPercent,actualDurationBenchmarkItem] forState:UIControlStateNormal];
                 [secondLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                 secondLabel.titleLabel.numberOfLines = 0;
                 secondLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
                 [secondLabel setHidden:NO];
                 secondLabel.backgroundColor = [UIColor clearColor];
                 [secondLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [secondLabel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                 [secondLabel addTarget:self action:@selector(secondLabelAction:) forControlEvents:UIControlEventTouchUpInside];
                 [secondLabel setUserInteractionEnabled:YES];
                 [thisRiser setUserInteractionEnabled:YES];


             }];
        }
            break;

        default:
            break;
    }
}
}

-(IBAction)firstLabelAction:(UIButton*)sender

{
    [self performSegueWithIdentifier:@"detailViewPush" sender:firstLabel];
}


-(void) secondLabelAction:(UIButton*)sender
{
    [self performSegueWithIdentifier:@"detailViewPush" sender:secondLabel];
}


@end