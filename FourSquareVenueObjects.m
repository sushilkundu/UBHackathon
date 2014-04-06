//
//  FourSquareVenueObjects.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "FourSquareVenueObjects.h"
#import "NSObject+NSCoding.h"
@implementation FourSquareVenueObjects
@synthesize name
,contact
,location
,url
,categories;

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
