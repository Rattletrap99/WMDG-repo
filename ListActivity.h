//
//  ListActivity.h
//  WMDGx
//
//  Created by Tim Jones on 2/23/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListCategory;

@interface ListActivity : NSManagedObject

@property (nonatomic, retain) NSString * activityCategory;
@property (nonatomic, retain) NSString * activityName;
@property (nonatomic, retain) ListCategory *listCategory;

@end
