//
//  ColorPickerView.m
//  WMDGx
//
//  Created by Tim Jones on 6/10/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "ColorPickerView.h"

AddCategoryViewController *addCatVC;

@implementation ColorPickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint loc = [touch locationInView:self];
    self.pickedColor = [self colorOfPoint:loc];
    NSLog(@"Touches began");
    
    addCatVC = [[AddCategoryViewController alloc]init];
    addCatVC.colorForColorView = self.pickedColor;
    
    NSLog(@"Picked color is %@",self.pickedColor);
    [addCatVC setColorview];
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.colorView.backgroundColor = self.cpv.pickedColor;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
