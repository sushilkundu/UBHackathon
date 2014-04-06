//
//  MainViewController.h
//  Hackathon
//
//  Created by sushil kundu on 4/5/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTimesFullObject.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *MainTableView;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong,nonatomic) NYTimesFullObject *newsObject;
@property (nonatomic,assign) int optionChosen;
@end
