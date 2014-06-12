//
//  CustomCatCell.m
//  WMDGx
//
//  Created by Tim Jones on 5/24/14.
//  Copyright (c) 2014 TDJ. All rights reserved.
//

#import "CustomCatCell.h"

@implementation CustomCatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
