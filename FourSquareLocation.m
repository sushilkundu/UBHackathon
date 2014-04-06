//
//  FourSquareLocation.m
//  Hackathon
//
//  Created by sushil kundu on 4/6/14.
//  Copyright (c) 2014 sushil kundu. All rights reserved.
//

#import "FourSquareLocation.h"
#import "NSObject+NSCoding.h"
@implementation FourSquareLocation
@synthesize  address,
crossStreet,
lat,
lng,
distance,
postalCode,
cc,
city,
state,
country;

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
