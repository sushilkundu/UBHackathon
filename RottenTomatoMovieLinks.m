//
//  RottenTomatoMovieLinks.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "RottenTomatoMovieLinks.h"
#import "NSObject+NSCoding.h"

@implementation RottenTomatoMovieLinks

@synthesize
alternate,
cast,
clips,
reviews,
similar;

- (void)encodeWithCoder:(NSCoder *)coder {
    [self autoEncodeWithCoder:coder];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        [self autoDecode:coder];
    }
    return self;
}


@end
