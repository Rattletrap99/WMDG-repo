//
//  CatColor.h
//  WMDGx
//
//  Created by Tim Jones on 6/9/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CatColor : NSManagedObject

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * isTaken;


+(void) loadColorsIntoCD;

@end
