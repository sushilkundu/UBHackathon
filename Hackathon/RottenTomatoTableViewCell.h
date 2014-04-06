//
//  RottenTomatoTableViewCell.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RottenTomatoMovieObject.h"

@interface RottenTomatoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *movieThumbImage;
+ (int)getRowHeightForMovie:(RottenTomatoMovieObject *)aMovie;
- (void)setDataForNewsItem:(RottenTomatoMovieObject *)aMovie;
@end
