//
//  FourSquareTableCellTableViewCell.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "FourSquareTableCellTableViewCell.h"
#import "FourSquareVenueObjects.h"

@implementation FourSquareTableCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (int)getRowHeightForVenue:(FourSquareVenueObjects *)afourSquareVenueObjects{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    if(afourSquareVenueObjects.categories && afourSquareVenueObjects.categories.count){
        _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    }
    CGSize _expectedLabelSize = [afourSquareVenueObjects.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 20;
    _expectedLabelSize = [[NSString stringWithFormat:@"%@,%@,%@",afourSquareVenueObjects.location.crossStreet,afourSquareVenueObjects.location.city,afourSquareVenueObjects.contact.phone] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 5;
    return _totalHeight>60?_totalHeight:60;
}

- (void)setDataForVenueObject:(FourSquareVenueObjects *)afourSquareVenueObjects{
    float _totalHeight = 5;
    CGSize _maximumLabelSize = CGSizeMake(290,FLT_MAX);
    if (afourSquareVenueObjects.categories && afourSquareVenueObjects.categories.count) {
        _maximumLabelSize = CGSizeMake(240,FLT_MAX);
    }
    CGSize _expectedLabelSize = [afourSquareVenueObjects.name sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    if (afourSquareVenueObjects.categories && afourSquareVenueObjects.categories.count) {
        if(!self.titleLabel){
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }else{
            [self.titleLabel setFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }
    }else{
        if(!self.titleLabel){
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }else{
            [self.titleLabel setFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }
    }

    _totalHeight = _totalHeight + _expectedLabelSize.height;
    _totalHeight = _totalHeight + 20;
        _expectedLabelSize = [[NSString stringWithFormat:@"%@,%@,%@",afourSquareVenueObjects.location.crossStreet,afourSquareVenueObjects.location.city,afourSquareVenueObjects.contact.phone] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10.0]  constrainedToSize:_maximumLabelSize  lineBreakMode:NSLineBreakByWordWrapping];
    if (afourSquareVenueObjects.categories && afourSquareVenueObjects.categories.count) {
        if(!self.addressLabel){
            self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }else{
            [self.addressLabel setFrame:CGRectMake(80, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }
    }else{
        if(!self.addressLabel){
            self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }else{
            [self.addressLabel setFrame:CGRectMake(5, _totalHeight , _expectedLabelSize.width, _expectedLabelSize.height)];
        }
    }

    if (afourSquareVenueObjects.categories && afourSquareVenueObjects.categories.count) {
        if (!self.fourSquareImage) {
            if (_totalHeight > 60) {
                self.fourSquareImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, _totalHeight/2 - 25, 70, _totalHeight/2 + 25)];
            }else{
                self.fourSquareImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 50)];
            }
        }else{
            if (_totalHeight > 60) {
                [self.fourSquareImage setFrame:CGRectMake(5, _totalHeight/2 - 25, 70, _totalHeight/2 + 25)];
            }else{
                [self.fourSquareImage setFrame:CGRectMake(5, 5, 70, 50)];
            }
        }
    }
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0]];
    [self.titleLabel setText:afourSquareVenueObjects.name];
    [self.titleLabel setTextColor:[UIColor blueColor]];
    [self addSubview:self.titleLabel];
    [self.addressLabel setNumberOfLines:0];
    [self.addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:10.0]];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@,%@,%@",afourSquareVenueObjects.location.crossStreet,afourSquareVenueObjects.location.city,afourSquareVenueObjects.contact.phone] ];
    [self.addressLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.addressLabel];
    [self addSubview:self.fourSquareImage];
}

@end
