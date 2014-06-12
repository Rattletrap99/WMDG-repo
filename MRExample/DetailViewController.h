//
//  DetailViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimedActivity.h"
#import "ReportViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"

//#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@property (weak, nonatomic) IBOutlet UILabel *focusItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *benchmarkItemLabel;

@property (weak,nonatomic) UIColor *itemOfInterestColor;
@property (weak,nonatomic) UIColor *benchmarkItemColor;

@property (strong,nonatomic) CustomCell *thisCustomCell;


@property (strong,nonatomic) NSString *detailFocusItem;
@property (strong,nonatomic) NSString *detailBenchmarkItem;
@property (strong,nonatomic) NSDate *detailStartDate;
@property (strong,nonatomic) NSDate *detailEndDate;
@property int activityOrCategory;


@end
