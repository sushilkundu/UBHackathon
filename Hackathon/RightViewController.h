//
//  RightViewController.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTimesFullObject.h"
#import <CoreLocation/CoreLocation.h>
#import "FourSquareFullObjects.h"
#import "JokesCompleteObject.h"
#import "RottenTomatoFullObject.h"

@interface RightViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *rightTable;
@property (strong,nonatomic) NSArray *menuArray;
@property (strong,nonatomic) NYTimesFullObject *newsObject;
@property (strong,nonatomic) FourSquareFullObjects *fourSquareRestaurantObj;
@property (strong,nonatomic) JokesCompleteObject *jokesObject;
@property (nonatomic,assign) CLLocationCoordinate2D coord;
@property (nonatomic,strong) RottenTomatoFullObject *rottenTomatoFullObject;

@end
