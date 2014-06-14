//
//  AddCategoryViewController.m
//  WMDGx
//
//  Created by Tim Jones on 3/6/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "AddCategoryViewController.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

NSMutableArray *array;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.catTextField.delegate = self;
    self.myCollectionView.delegate = self;
    
    NSLog(@"Color view is %@",self.colorChip);//_colorView	UIView *	0x8a63d30	0x08a63d30
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.catTextField resignFirstResponder];
    return YES;
}

#pragma mark Collection View stuff

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSFetchedResultsController *colorFRC = [WMDGCategory MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:nil groupBy:nil delegate:nil];
    return colorFRC.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSFetchedResultsController *colorFRC = [WMDGCategory MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:nil groupBy:nil delegate:nil];
    WMDGCategory *thisCategory = [colorFRC objectAtIndexPath:indexPath];
    
    [cell setBackgroundColor:thisCategory.color];
    [cell.layer setCornerRadius:7.0f];
    [cell setUserInteractionEnabled:YES];

    return cell;
}


#pragma mark Color Picker stuff

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] != 1)
        return;
    
    UIView *pickerImageView = [self.view viewWithTag:100];
    
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(pickerImageView.frame, p))
    {
//        printf("Hit gradient!\n");
        p = [touch locationInView:pickerImageView];
        UIColor *c = [self getPixelColor:[UIImage imageNamed:@"ColorPicker280.png"]
                                    xLoc:p.x
                                    yLoc:p.y];
        
        UIView *display = [self.view viewWithTag:200]; // representative color
        [display.layer setCornerRadius:20.0f];
        [display setBackgroundColor:c];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] != 1)
        return;
    
    UIView *pickerImageView = [self.view viewWithTag:100];
    
    UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
    CGPoint p = [touch locationInView:self.view];
    if (CGRectContainsPoint(pickerImageView.frame, p))
    {
//        printf("Hit gradient!\n");
        p = [touch locationInView:pickerImageView];
        UIColor *c = [self getPixelColor:[UIImage imageNamed:@"ColorPicker280.png"]
                                    xLoc:p.x
                                    yLoc:p.y];
        
        UIView *display = [self.view viewWithTag:200]; // representative color
        [display.layer setCornerRadius:20.0f];
        [display setBackgroundColor:c];
    }
}



- (UIColor*)getPixelColor:(UIImage *)image xLoc:(int)x yLoc:(int)y
{
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    if (x < 0 || x >= image.size.width || y < 0 || y >= image.size.height)
    {
        CFRelease(pixelData);
        return [UIColor whiteColor];
    }
    int pixelInfo = ((image.size.width  * y) + x ) * 4;
    
    UInt8 red = data[pixelInfo];
    UInt8 green = data[(pixelInfo + 1)];
    UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);
    
    UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    
    return color;
}

#pragma mark Save and Cancel Buttons


- (IBAction)saveButton:(UIBarButtonItem *)sender
{
    if (self.catTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No category created"
                                                        message:@"Please create a new category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if (!self.colorChip.backgroundColor)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No color selected"
                                                        message:@"Please select a color for your new category"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        self.thisCategory = [WMDGCategory MR_createInContext:localContext];
        self.thisCategory.name = [self.catTextField.text uppercaseString];
        self.thisCategory.color = self.colorChip.backgroundColor;
        [localContext MR_saveToPersistentStoreAndWait];
//        [self.thisCell setUserInteractionEnabled:NO];
        [self.delegate addCatControllerDidSave];
    }
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
        [self.delegate addCatControllerDidCancel:self.thisCategory];
    
}

@end

