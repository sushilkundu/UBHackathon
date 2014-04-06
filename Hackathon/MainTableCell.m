//
//  MainTableCell.m
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "MainTableCell.h"
#import "Result.h"

@implementation MainTableCell

- (void)awakeFromNib
{
    // Initialization code
}

+ (int)getRowHeightForNYTimesResult:(Result *)aResult{
    float _totalHeight = 4;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    if (aResult.thumbnailStandard && ![aResult.thumbnailStandard isEqualToString:@""]) {
        _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    }
    CGSize _expectedLabelSize = [aResult.abstract sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 2;
    
    return _totalHeight>60?_totalHeight:60;
}

- (void)setDataForNewsItem:(Result *)aResult{
    float _totalHeight = 4;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    if (aResult.thumbnailStandard && ![aResult.thumbnailStandard isEqualToString:@""]) {
        _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    }
    CGSize _expectedLabelSize = [aResult.abstract sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    if(!self.label){
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }else{
        [self.label setFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }
    if (aResult.thumbnailStandard && ![aResult.thumbnailStandard isEqualToString:@""]) {
        [self.label setFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }
    if (!self.image) {
        if (_totalHeight > 60) {
             self.image = [[UIImageView alloc] initWithFrame:CGRectMake(5, _totalHeight/2 - 25, 70, _totalHeight/2 + 25)];
        }else{
             self.image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 50)];
        }
       
    }
    [self.label setNumberOfLines:0];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]];
    [self.label setText:aResult.abstract];
    [self.label setTextColor:[UIColor blackColor]];
    [self addSubview:self.label];
    [self addSubview:self.image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
