//
//  AvsAViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDGActivity.h"
#import "WMDGCategory.h"
#import "SearchSpecs.h"
#import "TimedActivity.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@class ReportViewController;



@protocol AvsAViewControllerDelegate

-(void) AvsAViewControllerIsDone: (SearchSpecs *) specForGraph;

-(void) AvsAViewControllerDidCancel:(SearchSpecs *) activityToDelete;

@end


@interface AvsAViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>


@property (nonatomic, weak) id <AvsAViewControllerDelegate> delegate;



@property (strong, nonatomic) SearchSpecs *currentSpec;


//@property BOOL *firstActivitySelected;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *firstActivityLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondActivityLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeFrameLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainSelectLabel;



@property (retain) NSIndexPath *lastIndexPath;

@property (strong, nonatomic) IBOutlet UISegmentedControl *timeFrameButton;


//@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;


- (IBAction)clearButton:(UIButton *)sender;

- (IBAction)setButton:(UIButton *)sender;

- (IBAction)timeFrameSelector:(UISegmentedControl *)sender;


@end
