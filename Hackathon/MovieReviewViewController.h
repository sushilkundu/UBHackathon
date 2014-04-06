//
//  MovieReviewViewController.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RottenTomatoFullObject.h"

@interface MovieReviewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *movieReviewTable;
@property(strong,nonatomic) RottenTomatoFullObject *rottenTomatoFullObject;
@end
