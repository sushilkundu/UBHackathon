//
//  JokesTableViewCell.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *jokeLabel;
-(void) setData:(NSString *)joke;
+ (int)getRowHeightForJokes:(NSString *)aJoke;
@end
