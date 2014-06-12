//
//  CvsCViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSpecs.h"
#import "WMDGActivity.h"
#import "WMDGCategory.h"
#import "TimedActivity.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@class ReportViewController;

@protocol CvsCViewControllerDelegate

-(void) CvsCViewControllerIsDone:(SearchSpecs *) specForGraph;

-(void) CvsCViewControllerDidCancel:(SearchSpecs *) activityToDelete;

@end


@interface CvsCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) id <CvsCViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) SearchSpecs *currentSpec;
@property (retain) NSIndexPath *lastIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *mainSelectLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeFrameLabel;

@property (strong, nonatomic) IBOutlet UILabel *firstCategoryLabel;

@property (strong, nonatomic) IBOutlet UILabel *secondCategorylabel;


- (IBAction)setButton:(UIButton *)sender;

- (IBAction)clearButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *timeFrameButton;

- (IBAction)timeFrameSelector:(UISegmentedControl *)sender;










@end
