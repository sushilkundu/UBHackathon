//
//  RottenTomatoFullObject.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RottenTomatoHomeLinks.H"

@interface RottenTomatoFullObject : NSObject
@property (nonatomic, strong) NSString *linkTemplate;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) RottenTomatoHomeLinks *links;

@end
