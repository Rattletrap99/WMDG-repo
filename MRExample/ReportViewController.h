//
//  ReportViewController.h
//  MRExample
//
//  Created by Tim Jones on 12/1/13.
//  Copyright (c) 2013 TDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSpecs.h"
#import "AvsAViewController.h"
#import "CvsCViewController.h"
#import "TimedActivity.h"
#import "RiserBar.h"
#import "DetailViewController.h"

@class DetailViewController;

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]



@interface  ReportViewController: UIViewController <CvsCViewControllerDelegate, AvsAViewControllerDelegate, UIActionSheetDelegate>

//-(void) buttonForSegue:sender;

- (IBAction)goButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCompButton;

- (IBAction)selectCompButton:(UIButton *)sender;

-(IBAction)firstLabelAction:(UIButton*)sender;



@property (strong,nonatomic) TimedActivity *currentActivityForComp;

@property (strong,nonatomic) SearchSpecs *specForGraph;

@property (strong,nonatomic) SearchSpecs *thisSpec;

@property (weak, nonatomic) IBOutlet UIView *chartView;

@property (strong,nonatomic) UILabel *aux1Label;
@property (strong,nonatomic) UILabel *aux2Label;

@property (strong,nonatomic) UIActionSheet *comparisonSelectorActionSheet;


@end
