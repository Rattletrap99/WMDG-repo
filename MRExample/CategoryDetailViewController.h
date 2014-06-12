//
//  CvsAllViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportViewController.h"

@interface CategoryDetailViewController : UIViewController

@property (strong,nonatomic) NSString *detailName;

@property (strong,nonatomic) NSDate *detailStartDate;

@property (strong,nonatomic) NSDate *detailEndDate;


@end
