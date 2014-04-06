//
//  RightViewTableCellTableViewCell.m
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "RightViewTableCellTableViewCell.h"

@implementation RightViewTableCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 300, 20)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
