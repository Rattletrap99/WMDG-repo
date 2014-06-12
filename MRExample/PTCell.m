//
//  PTCell.m
//  WMDGx
//
//  Created by Tim Jones on 3/12/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "PTCell.h"

@implementation PTCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateDurationLabel {
    
    //Which calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Gets the componentized interval from the most recent time an activity was tapped until now
    
    NSDateComponents *components= [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self.startTime toDate:[NSDate date] options:0];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds =[components second];

    // Converts the components to a string and displays it in the duration label, updated via the timer
    
    NSString * cellLabelTempText = [NSString stringWithFormat:@"%02i:%02i:%02i",hours,minutes,seconds];
    self.durationLabel.text = cellLabelTempText;
    
    
    
//    NSLog(@"current name is %@",self.currentTimedActivityName);
//    NSLog(@"previous name is %@",self.previousTimedActivityName);
   
}

-(void) startTimer
{
    [self stopTimer];
    self.startTime = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(updateDurationLabel) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];

    
}

-(void) startBlinkTimer
{
    [self stopBlinkTimer];
    self.sleepLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(blinkSleepLabel) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.sleepLabelTimer
                                 forMode:NSRunLoopCommonModes];

}


-(void) blinkSleepLabel
{
    [self.sleepLabel setHidden:(!self.sleepLabel.hidden)];
}

-(void) stopBlinkTimer
{
    [self.sleepLabelTimer invalidate];
    self.sleepLabelTimer = nil;
}


-(void) zeroTimer
{
    NSString * cellLabelZeroText = [NSString stringWithFormat:@"%02i:%02i:%02i",0,0,0];
    self.durationLabel.text = cellLabelZeroText;

}


-(void) stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
