//
//  JokesViewController.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JokesCompleteObject.h"
@interface JokesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *jokesTable;
@property (strong,nonatomic) JokesCompleteObject *jokeObject;
@end
