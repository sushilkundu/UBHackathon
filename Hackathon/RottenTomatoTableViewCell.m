//
//  RottenTomatoTableViewCell.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "RottenTomatoTableViewCell.h"
#import "RottenTomatoMovieObject.h"

@implementation RottenTomatoTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (int)getRowHeightForMovie:(RottenTomatoMovieObject *)aMovie{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    CGSize _expectedLabelSize = [aMovie.synopsis sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 5;
    
    return _totalHeight>60?_totalHeight:60;
}

- (void)setDataForNewsItem:(RottenTomatoMovieObject *)aMovie{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    CGSize _expectedLabelSize = [aMovie.synopsis sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    if(!self.movieNameLabel){
        self.movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }else{
        [self.movieNameLabel setFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }
    if (!self.movieThumbImage) {
        if (_totalHeight > 60) {
            self.movieThumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, _totalHeight/2 - 25, 70, _totalHeight/2 + 25)];
        }else{
            self.movieThumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 50)];
        }
        
    }
    [self.movieNameLabel setNumberOfLines:0];
    [self.movieNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0]];
    [self.movieNameLabel setText:aMovie.synopsis];
    [self.movieNameLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.movieNameLabel];
    [self addSubview:self.movieThumbImage];
}

@end
