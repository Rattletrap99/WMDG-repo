//
//  WMDGCategory.h
//  WMDGx
//
//  Created by Tim Jones on 5/23/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WMDGActivity;

@interface WMDGCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * isItNew;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSSet *activities;
@end

@interface WMDGCategory (CoreDataGeneratedAccessors)

- (void)addActivitiesObject:(WMDGActivity *)value;
- (void)removeActivitiesObject:(WMDGActivity *)value;
- (void)addActivities:(NSSet *)values;
- (void)removeActivities:(NSSet *)values;

@end
