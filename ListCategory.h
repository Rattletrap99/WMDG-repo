//
//  ListCategory.h
//  WMDGx
//
//  Created by Tim Jones on 2/23/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListActivity;

@interface ListCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * isItNew;
@property (nonatomic, retain) NSSet *listActivities;
@end

@interface ListCategory (CoreDataGeneratedAccessors)

- (void)addListActivitiesObject:(ListActivity *)value;
- (void)removeListActivitiesObject:(ListActivity *)value;
- (void)addListActivities:(NSSet *)values;
- (void)removeListActivities:(NSSet *)values;

@end
