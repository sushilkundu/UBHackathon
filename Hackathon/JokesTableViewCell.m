//
//  JokesTableViewCell.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "JokesTableViewCell.h"

@implementation JokesTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setData:(NSString *)joke{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    CGSize _expectedLabelSize = [joke sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    if(!self.jokeLabel){
        self.jokeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }else{
        [self.jokeLabel setFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
    }
    [self.jokeLabel setNumberOfLines:0];
    [self.jokeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
    [self.jokeLabel setText:joke];
    [self.jokeLabel setTextColor:[UIColor grayColor]];
    [self addSubview:self.jokeLabel];
}

+ (int)getRowHeightForJokes:(NSString *)aJoke{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    CGSize _expectedLabelSize = [aJoke sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 5;
    return _totalHeight;
}

@end
