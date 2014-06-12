//
//  ActivityDetailViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimedActivity.h"
#import "ReportViewController.h"

@interface ActivityDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;


@property (strong,nonatomic) NSString *detailFocusItem;
@property (strong,nonatomic) NSString *detailBenchmarkItem;
@property (strong,nonatomic) NSDate *detailStartDate;
@property (strong,nonatomic) NSDate *detailEndDate;
@property int activityOrCategory;


@end
