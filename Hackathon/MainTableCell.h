//
//  MainTableCell.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Result.h"

@interface MainTableCell : UITableViewCell
+ (int)getRowHeightForNYTimesResult:(Result *)aResult;
- (void)setDataForNewsItem:(Result *)aResult;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@end
