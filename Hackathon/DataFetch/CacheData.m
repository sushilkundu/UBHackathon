//
//  CacheData.m
//  TOI
//
//  Created by Ravi Sahu on 28/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CacheData.h"
#import "NSObject+NSCoding.h"

@implementation CacheData

@synthesize cacheCreatedDateTime;
@synthesize cachedData;

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
