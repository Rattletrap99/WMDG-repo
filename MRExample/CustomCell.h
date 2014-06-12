//
//  CustomCell.h
//  WMDGx
//
//  Created by Tim Jones on 5/14/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DetailViewController.h"

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UIView  *myBGView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
