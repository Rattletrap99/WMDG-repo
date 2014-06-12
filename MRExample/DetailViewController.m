//
//  DetailViewController.m
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "DetailViewController.h"
//#import "CustomCell.h"

@interface DetailViewController ()

@end

NSFetchedResultsController *detailFRC;
NSPredicate *frcPredicate;
TimedActivity *thisActivity;
//CustomCell *cell;


@implementation DetailViewController

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
        
    frcPredicate = [NSPredicate predicateWithFormat:@"(startTime >= %@ AND stopTime <= %@) OR ((startTime <= %@ AND stopTime >= %@) OR (startTime <= %@ AND stopTime == NULL))",self.detailStartDate,self.detailEndDate,self.detailStartDate,self.detailStartDate,self.detailEndDate];


    NSLog(@"detailStartDate is %@",self.detailStartDate);
    NSLog(@"detailEndDate is %@",self.detailEndDate);
    
    self.focusItemLabel.text = self.detailFocusItem;
    self.focusItemLabel.textColor = self.itemOfInterestColor;
    self.benchmarkItemLabel.text = self.detailBenchmarkItem;
    self.benchmarkItemLabel.textColor = self.benchmarkItemColor;


    detailFRC = [TimedActivity MR_fetchAllSortedBy:@"startTime" ascending:NO withPredicate:frcPredicate groupBy:nil delegate:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[detailFRC sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.thisCustomCell = [tableView dequeueReusableCellWithIdentifier:@"myCustomCell"];
    
    if (!self.thisCustomCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"myCustomCell"];
        self.thisCustomCell = [tableView dequeueReusableCellWithIdentifier:@"myCustomCell"];
    }

    return self.thisCustomCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)thisCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    thisActivity = [detailFRC objectAtIndexPath:indexPath];
    self.thisCustomCell.activityLabel.text = thisActivity.name;
    self.thisCustomCell.categoryLabel.text = [thisActivity.category uppercaseString];
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.thisCustomCell.backgroundView = backgroundView;
    
    for (UIView* view in self.thisCustomCell.contentView.subviews)
    {
        view.backgroundColor = [UIColor clearColor];
    }
    
    [self.thisCustomCell.contentView.layer setCornerRadius:20.0f];
    [self.thisCustomCell.contentView.layer setBorderWidth:6.0f];

    if (self.activityOrCategory == 0) // Activity vs Activity
    {
            if ([thisActivity.name isEqualToString:self.detailFocusItem])
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor whiteColor]];
                [self.thisCustomCell.contentView.layer setBorderColor:self.itemOfInterestColor.CGColor];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor blackColor]];
            }
        
            else if ([thisActivity.name isEqualToString:self.detailBenchmarkItem])
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor whiteColor]];
                [self.thisCustomCell.contentView.layer setBorderColor:self.benchmarkItemColor.CGColor];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor blackColor]];
            }
        
            else // Not an item of interest
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor colorWithRed:0.962f green:0.962f blue:0.962f alpha:1.00f]];
                [self.thisCustomCell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            }
    }
    
    else if (self.activityOrCategory == 1) // Category vs Category

    {
            if ([thisActivity.category isEqualToString:self.detailFocusItem])
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor whiteColor]];
                [self.thisCustomCell.contentView.layer setBorderColor:self.itemOfInterestColor.CGColor];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor blackColor]];

            }
        
            else if ([thisActivity.category isEqualToString:self.detailBenchmarkItem])
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor whiteColor]];
                [self.thisCustomCell.contentView.layer setBorderColor:self.benchmarkItemColor.CGColor];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor blackColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor blackColor]];
            }
        
            else // Not an item of interest
            {
                [self.thisCustomCell.activityLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.categoryLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.fromDateLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.toDateLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.durationLabel setTextColor:[UIColor lightGrayColor]];
                [self.thisCustomCell.contentView setBackgroundColor:[UIColor colorWithRed:0.962f green:0.962f blue:0.962f alpha:1.00f]];
                [self.thisCustomCell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            }
    }
    [self updateOtherLabels];
    [self updateDurationLabel];
}

-(void) updateOtherLabels
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"MM/dd/yy hh:mm a"];
    
//    [earlyEdgeCaseObject.stopTime timeIntervalSinceDate:self.thisSpec.fromDate]
//    if (([thisActivity.startTime timeIntervalSince1970]  < [self.detailStartDate timeIntervalSince1970] ) && ([thisActivity.stopTime timeIntervalSince1970] > [self.detailStartDate timeIntervalSince1970]))


    if (([thisActivity.startTime timeIntervalSinceDate:self.detailStartDate] < 0) && ([thisActivity.stopTime timeIntervalSinceDate:self.detailStartDate] > 0))
    {
        self.thisCustomCell.fromDateLabel.text = @"STARTED EARLIER";
        
        
        NSLog(@"FromDateLabel text is %@",self.thisCustomCell.fromDateLabel.text);
        NSLog(@"self.detailStartDate is %@",[dateFormat stringFromDate:thisActivity.startTime]);

    }
    
    else
    {
        self.thisCustomCell.fromDateLabel.text = [dateFormat stringFromDate:thisActivity.startTime];
    }
    
    if (thisActivity.stopTime == NULL)
    {
        self.thisCustomCell.toDateLabel.text = @"RUNNING";
    }
    
    else
    {
        self.thisCustomCell.toDateLabel.text = [dateFormat stringFromDate:thisActivity.stopTime];
    }

}

-(void)updateDurationLabel
{
    //Which calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Gets the componentized interval from the most recent time an activity was tapped until now
    
    if (thisActivity.stopTime == NULL)
    {
        NSDateComponents *components= [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:thisActivity.startTime toDate:[NSDate date] options:0];
        NSInteger days = [components day];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        NSInteger seconds =[components second];
        self.thisCustomCell.durationLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
    }
    
    else if (!(thisActivity.stopTime == NULL))
    {
        NSDateComponents *components= [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:thisActivity.startTime toDate:thisActivity.stopTime options:0];
        NSInteger days = [components day];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        NSInteger seconds =[components second];
        self.thisCustomCell.durationLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
    }
    
    if ([self.thisCustomCell.fromDateLabel.text isEqualToString:@"STARTED EARLIER"])
    {
        NSDateComponents *components= [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self.detailStartDate toDate:thisActivity.stopTime options:0];
        NSInteger days = [components day];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        NSInteger seconds =[components second];
        
        // Shows actual et within timeframe for early straddle case
        
        self.thisCustomCell.durationLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i:%02i",days,hours,minutes,seconds];
        self.thisCustomCell.durationLabel.textColor = [UIColor redColor];
    }
}






@end
