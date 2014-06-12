//
//  SearchSpecs.h
//  WMDGx
//
//  Created by Tim Jones on 3/5/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchSpecs : NSManagedObject

@property (nonatomic, retain) NSString * activityOfInterest;
@property (nonatomic, retain) NSString * benchmarkActivity;
@property (nonatomic, retain) NSString * benchmarkCategory;
@property (nonatomic, retain) NSString * categoryOfInterest;
@property (nonatomic, retain) NSDate * fromDate;
@property (nonatomic, retain) NSDate * toDate;

@end
