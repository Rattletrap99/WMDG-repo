//
//  TimedActivity.h
//  WMDGx
//
//  Created by Tim Jones on 5/30/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimedActivity : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * stopTime;

@end
