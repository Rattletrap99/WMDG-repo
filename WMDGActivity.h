//
//  WMDGActivity.h
//  WMDGx
//
//  Created by Tim Jones on 3/5/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WMDGCategory;

@interface WMDGActivity : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) WMDGCategory *toCategory;

@end
