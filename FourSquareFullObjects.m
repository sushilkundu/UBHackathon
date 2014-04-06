//
//  FourSquareFullObjects.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "FourSquareFullObjects.h"
#import "NSObject+NSCoding.h"

@implementation FourSquareFullObjects
@synthesize meta,response;

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
