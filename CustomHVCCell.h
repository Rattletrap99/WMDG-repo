//
//  CustomHVCCell.h
//  WMDGx
//
//  Created by Tim Jones on 6/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeViewController.h"
@class HomeViewController;

@interface CustomHVCCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *hvcCellActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hvcCellCategoryLabel;

@end
