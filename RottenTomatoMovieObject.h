//
//  RottenTomatoMovieObject.h
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RottenTomatoPosterObject.h"
#import "RottenTomatoMovieLinks.h"


@interface RottenTomatoMovieObject : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *criticsConsensus;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) RottenTomatoPosterObject *posters;
@property (nonatomic, strong) RottenTomatoMovieLinks *links;

@end
