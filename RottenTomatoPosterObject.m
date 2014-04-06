//
//  RottenTomatoPosterObject.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "RottenTomatoPosterObject.h"
#import "NSObject+NSCoding.h"

@implementation RottenTomatoPosterObject
@synthesize
thumbnail,
profile,
detailed,
original;

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
