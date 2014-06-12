//
//  StatsViewController.h
//  MRExample
//
//  Created by Tim Jones on 1/18/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "TimedActivity.h"


@interface StatsViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate>

//@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@end
