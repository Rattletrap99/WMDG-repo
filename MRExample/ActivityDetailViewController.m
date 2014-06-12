//
//  ActivityDetailViewController.m
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController ()

@end

NSFetchedResultsController *detailFRC;


@implementation ActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview datasource methods

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//}

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    NSPredicate *detailPredicate = [NSPredicate predicateWithFormat:@"name == %@"]
//    
//    // Configure the cell to show the activity's name
//    TimedActivity *detailActivity = [detailFRC objectAtIndexPath:indexPath];
//    cell.textLabel.text = detailActivity.name;
//    cell.textLabel.textColor = [UIColor whiteColor];
//    NSAttributedString *attString;
//    attString = cell.textLabel.attributedText;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}











@end
