//
//  PTCell.h
//  WMDGx
//
//  Created by Tim Jones on 3/12/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UILabel *sleepLabel;


@property (nonatomic, strong) NSString * currentTimedActivityName;
@property (nonatomic, strong) NSString * previousTimedActivityName;

@property (strong, nonatomic) NSTimer *sleepLabelTimer;

@property (nonatomic, strong) NSDate * startTime;
@property (nonatomic, strong) NSTimer * timer;


-(void) updateDurationLabel;
-(void) startTimer;
-(void) stopTimer;
-(void) zeroTimer;
-(void) startBlinkTimer;
-(void) blinkSleepLabel;
-(void) stopBlinkTimer;



@end
