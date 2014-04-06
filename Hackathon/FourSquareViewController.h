//
//  FourSquareViewController.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquareFullObjects.h"

@interface FourSquareViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *fourSquareTable;
@property (strong,nonatomic) FourSquareFullObjects *fourSquareRestaurantObj;

@end
