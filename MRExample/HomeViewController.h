//
//  HomeViewController.h
//  MRExample
//
//  Created by Tim Jones on 1/15/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDGCategory.h"
#import "WMDGActivity.h"
#import "AddActivityViewController.h"
#import "AddCategoryViewController.h"
#import "TimedActivity.h"
#import "CustomHVCCell.h"

@interface HomeViewController : UIViewController <AddActivityViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) TimedActivity * currentTimedActivity;
@property (strong, nonatomic) TimedActivity * previousTimedActivity;

@property (strong, nonatomic) WMDGActivity *thisParticularActivity;
@property (strong, nonatomic) WMDGCategory *thisParticularCategory;



@property (strong,nonatomic) CustomHVCCell *thisCustomHVCCell;

@property (strong, nonatomic) IBOutlet UILabel *currentlyTimedLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *topPanelView;

@property (weak, nonatomic) IBOutlet UIView *windowView;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *durationOrSleepLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeStopperButton;



@property (strong, nonatomic) NSTimer *sleepLabelTimer;

@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic, strong) NSTimer * timer;

//@property WMDGActivity *currentActivity;

//@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property NSManagedObjectContext * moc;
@property NSDate *stopTimeHolder;

@property (weak, nonatomic) IBOutlet UIButton *dumpMemoryButton;

- (IBAction)dumpMemory:(UIButton *)sender;

- (IBAction)stopTimerButton:(UIButton *)sender;




-(void) updateDurationLabel;
-(void) startDurationTimer;
-(void) stopDurationTimer;
-(void) zeroTimer;
-(void) startBlinkTimer;
-(void) blinkSleepLabel;
-(void) stopBlinkTimer;


@end