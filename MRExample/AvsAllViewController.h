//
//  AvsAllViewController.h
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvsAllViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@property (strong,nonatomic) NSString *detailName;

@property (strong,nonatomic) NSDate *detailStartDate;

@end
