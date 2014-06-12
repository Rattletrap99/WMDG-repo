//
//  AvsAllViewController.m
//  WMDGx
//
//  Created by Tim Jones on 2/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "AvsAllViewController.h"

@interface AvsAllViewController ()

@end

NSFetchedResultsController *detailFRC;


@implementation AvsAllViewController

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

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    // Configure the cell to show the activity's name
//    WMDGActivity *thisActivity = [actFRC objectAtIndexPath:indexPath];
//    cell.textLabel.text = thisActivity.name;
//    cell.textLabel.textColor = [UIColor whiteColor];
//    NSAttributedString *attString;
//    attString = cell.textLabel.attributedText;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    
//}










@end
