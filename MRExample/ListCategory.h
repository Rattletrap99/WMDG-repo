//
//  ListCategory.h
//  WMDGx
//
//  Created by Tim Jones on 3/5/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WMDGActivity;

@interface ListCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isItNew;
@property (nonatomic, retain) NSSet *activities;
@end

@interface ListCategory (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(WMDGActivity *)value;
- (void)removeActivitiesObject:(WMDGActivity *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

@end
