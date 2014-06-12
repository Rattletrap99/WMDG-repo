//
//  CatColor.m
//  WMDGx
//
//  Created by Tim Jones on 6/9/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "CatColor.h"


@implementation CatColor

@dynamic color;
@dynamic idNumber;
@dynamic isTaken;


+(void) loadColorsIntoCD
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    int tag = 0;
    float INCREMENT = 0.01;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT)
    {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        CatColor *thisColor = [CatColor MR_createInContext:localContext];
        thisColor.color = color;
        thisColor.isTaken = NO;
        tag++;
        thisColor.idNumber = [NSNumber numberWithInt:tag];
        NSLog(@"ThisColor.idNumber is %@",thisColor.idNumber);
        NSLog(@"ThisColor.color is %@",thisColor.color);
        [localContext MR_saveToPersistentStoreAndWait];
    }
    NSLog(@"%i CatColors available", [CatColor MR_countOfEntities]);
}

@end










