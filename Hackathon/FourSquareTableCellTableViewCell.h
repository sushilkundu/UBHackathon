//
//  FourSquareTableCellTableViewCell.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquareVenueObjects.h"

@interface FourSquareTableCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *fourSquareImage;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
+ (int)getRowHeightForVenue:(FourSquareVenueObjects *)afourSquareVenueObjects;
- (void)setDataForVenueObject:(FourSquareVenueObjects *)afourSquareVenueObjects;
@end
